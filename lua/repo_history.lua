-- lua/repo_history.lua
-- Per-git-repo file history, stored in stdpath("data")/repo_history.json
-- Replaces the lossy global v:oldfiles / shada-based oldfiles picker.

local M = {}

local DATA_FILE = vim.fn.stdpath("data") .. "/repo_history.json"
local MAX_PER_REPO = 1000

-- ─── Internal state ───────────────────────────────────────────────────────────

local _data = nil            -- lazy-loaded table: { [root] = { "rel/path", ... } }
local _root_cache = {}       -- dir → git-root (or false when not in a repo)

-- ─── Persistence ──────────────────────────────────────────────────────────────

local function load()
  if _data then return _data end
  local f = io.open(DATA_FILE, "r")
  if not f then
    _data = {}
    return _data
  end
  local content = f:read("*a")
  f:close()
  if not content or content == "" then
    _data = {}
    return _data
  end
  local ok, decoded = pcall(vim.fn.json_decode, content)
  _data = (ok and type(decoded) == "table") and decoded or {}
  return _data
end

local function save()
  if not _data then return end
  local ok, encoded = pcall(vim.fn.json_encode, _data)
  if not ok then return end
  local f = io.open(DATA_FILE, "w")
  if not f then return end
  f:write(encoded)
  f:close()
end

-- ─── Git root (cached per directory) ─────────────────────────────────────────

local function git_root(dir)
  if _root_cache[dir] ~= nil then
    -- cached: false means "not a repo"
    return _root_cache[dir] or nil
  end
  local result = vim.fn.systemlist(
    "git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null"
  )
  if vim.v.shell_error ~= 0 or #result == 0 then
    _root_cache[dir] = false
    return nil
  end
  local root = result[1]
  _root_cache[dir] = root
  return root
end

-- ─── Core: record a buffer visit ─────────────────────────────────────────────

function M.record()
  local bufnr = vim.api.nvim_get_current_buf()
  local file  = vim.api.nvim_buf_get_name(bufnr)

  -- Skip unnamed, special (quickfix, terminal…), or protocol buffers (oil://, …)
  if file == "" then return end
  if vim.bo[bufnr].buftype ~= "" then return end
  if file:match("^%a+://") then return end

  local abs = vim.fn.fnamemodify(file, ":p")
  local dir = vim.fn.fnamemodify(abs, ":h")
  local root = git_root(dir)
  if not root then return end

  -- Store as path relative to repo root for portability
  local rel = abs
  if abs:sub(1, #root + 1) == root .. "/" then
    rel = abs:sub(#root + 2)
  end

  local data = load()
  local list = data[root] or {}

  -- Remove any existing entry for this file (dedup, promote to top)
  for i, v in ipairs(list) do
    if v == rel then
      table.remove(list, i)
      break
    end
  end

  table.insert(list, 1, rel)                 -- prepend → most-recent first

  while #list > MAX_PER_REPO do              -- cap per-repo list
    list[#list] = nil
  end

  data[root] = list
  save()                                     -- flush to disk on every visit
end

-- ─── Picker ───────────────────────────────────────────────────────────────────

function M.pick()
  -- Resolve git root from current buffer, falling back to cwd
  local buf_name = vim.api.nvim_buf_get_name(0)
  local dir
  if buf_name ~= "" then
    dir = vim.fn.fnamemodify(buf_name, ":h"):gsub("^%a+://", "")
  else
    dir = vim.fn.getcwd()
  end

  local root = git_root(dir) or git_root(vim.fn.getcwd())
  if not root then
    vim.notify("repo-history: not inside a git repository", vim.log.levels.WARN)
    return
  end

  local data = load()
  local list = data[root] or {}

  -- Filter out files that no longer exist on disk
  local entries = {}
  for _, rel in ipairs(list) do
    if vim.fn.filereadable(root .. "/" .. rel) == 1 then
      table.insert(entries, rel)
    end
  end

  if #entries == 0 then
    vim.notify("repo-history: no history yet for " .. vim.fn.fnamemodify(root, ":t"), vim.log.levels.INFO)
    return
  end

  local fzf = require("fzf-lua")
  fzf.fzf_exec(entries, {
    prompt   = "Repo History❯ ",
    cwd      = root,                         -- fzf-lua resolves relative paths against cwd
    fzf_opts = { ["--tiebreak"] = "index" }, -- preserve recency order
    actions  = {
      ["default"] = fzf.actions.file_edit,
      ["ctrl-s"]  = fzf.actions.file_split,
      ["ctrl-v"]  = fzf.actions.file_vsplit,
      ["ctrl-t"]  = fzf.actions.file_tabedit,
    },
  })
end

-- ─── Setup ────────────────────────────────────────────────────────────────────

function M.setup()
  load() -- pre-warm cache so first BufEnter has no cold-start disk read

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function() M.record() end,
    desc     = "repo-history: track opened files per git repo",
  })
end

return M
