local function get_github_url_from_origin()
  local handle = io.popen('git remote get-url origin 2> /dev/null')
  if not handle then return nil end

  local origin_url = handle:read("*a")
  handle:close()

  origin_url = origin_url:gsub("\n", "")
  origin_url = origin_url:gsub("git@(.+):(.+)", "https://%1/%2")
  origin_url = origin_url:gsub("%.git", "")
  return origin_url
end

local function go_commit()
  local api = vim.api
  local origin_url = get_github_url_from_origin()
  if not origin_url then
    api.nvim_err_writeln('Unable to determine origin URL')
    return
  end

  -- Get visual selection range
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  local lines = api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    api.nvim_err_writeln('No text selected')
    return
  end

  local selected_text
  if #lines == 1 then
    selected_text = lines[1]:sub(start_col, end_col)
  else
    lines[1] = lines[1]:sub(start_col)
    lines[#lines] = lines[#lines]:sub(1, end_col)
    selected_text = table.concat(lines, "")
  end

  local commit_hash = selected_text:match("%w+")
  if not commit_hash then
    api.nvim_err_writeln('No valid commit hash found in selection')
    return
  end

  local url = string.format("%s/commit/%s", origin_url, commit_hash)

  local open_cmd
  if vim.fn.has('mac') == 1 then
    open_cmd = 'open'
  elseif vim.fn.has('unix') == 1 then
    open_cmd = 'xdg-open'
  elseif vim.fn.has('win32') == 1 then
    open_cmd = 'start'
  else
    api.nvim_err_writeln('Unsupported OS')
    return
  end

  os.execute(string.format('%s %s', open_cmd, url))
end

vim.api.nvim_create_user_command('Gcommit', go_commit, { nargs = 0, range = true })
