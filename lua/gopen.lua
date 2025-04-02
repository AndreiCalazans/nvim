local function get_current_branch()
  local handle = io.popen('git rev-parse --abbrev-ref HEAD 2> /dev/null')
  local result = handle:read("*a")
  handle:close()
  return result:gsub("\n", "") -- Remove any newline characters
end

local function gopen(args)
  local api = vim.api
  local bufnr = api.nvim_get_current_buf()
  local file_path = api.nvim_buf_get_name(bufnr)
  local rel_path = vim.fn.fnamemodify(file_path, ':.')

  local line_start, line_end
  if args.range == 2 then
    line_start = args.line1
    line_end = args.line2
  else
    line_start = unpack(api.nvim_win_get_cursor(0))
    line_end = line_start
  end

  local handle = io.popen('git remote get-url origin 2> /dev/null')
  local origin_url = handle:read("*a")
  handle:close()

  origin_url = origin_url:gsub("\n", "") -- Remove any newline characters
  origin_url = origin_url:gsub("git@(.+):(.+)", "https://%1/%2")
  origin_url = origin_url:gsub("%.git", "")

  local main_branch = get_current_branch()

  local line_position = tostring(line_start)
  if line_end > line_start then
    line_position = tostring(line_start) .. '-L' .. tostring(line_end)
  end

  vim.api.nvim_out_write("origin_url: " .. origin_url .. "\n")
  vim.api.nvim_out_write("rel_path: " .. rel_path .. "\n")
  vim.api.nvim_out_write("line_position: " .. line_position .. "\n")

  local url = string.format("%s/blob/%s/%s#L%s", origin_url, main_branch, rel_path, line_position)

  vim.api.nvim_out_write("URL: " .. url .. "\n")

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

vim.api.nvim_create_user_command('Gopen', gopen, { range = true, nargs = 0 })
