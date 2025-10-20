require("fzf-lua").setup {
  winopts = { ... },     -- UI Options
  keymap = { ... },      -- Neovim keymaps / fzf binds
  actions = { ... },     -- Fzf "accept" binds
  fzf_opts = { ... },    -- Fzf CLI flags
  fzf_colors = { ... },  -- Fzf `--color` specification
  hls = { ... },         -- Highlights
  previewers = { ... },  -- Previewers options
  -- SPECIFIC COMMAND/PICKER OPTIONS, SEE BELOW
  -- files = { ... },
}

local builtin = require("fzf-lua")

local function liveGrep()
  builtin.live_grep({ rg_glob = true })
end

vim.keymap.set("n", ",e", builtin.files, {})
vim.keymap.set("n", ",E", builtin.oldfiles, {})
vim.keymap.set("n", ",f", liveGrep, {})
vim.keymap.set("n", ",b", builtin.buffers, {})
vim.keymap.set("n", ",Y", builtin.command_history, {})
vim.keymap.set("n", ",j", builtin.jumps, {})
vim.keymap.set("n", ",r", builtin.resume, {})
