local nvim_lsp = require('lspconfig')

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

local set_lsp_config = function(client, bufnr)
	require'completion'.on_attach(client)
	print("LSP started.");
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	buf_set_keymap('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
	buf_set_keymap('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

end

-- ESLINT Server
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintIgnoreExitCode = true,
}

local prettier = {
	formatCommand = "./node_modules/.bin/prettier --stdin-filepath=${INPUT}",
	formatStdin = true
}


-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
-- If you are adding a new language server remember that you need to install the LSP for it https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local servers = { "jsonls", "rust_analyzer", "html", "graphql", "dockerls", "clangd", "bashls", "dartls" }
-- Servers with extra overrides are at the bottom
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { 
    on_attach = set_lsp_config
    -- Uncomment the following if you want to remove LSP written errors to buffer
    -- handlers = {
    --    ["textDocument/publishDiagnostics"] = vim.lsp.with(
    --      vim.lsp.diagnostic.on_publish_diagnostics, {
    --        -- Disable virtual_text
    --        virtual_text = false
    --      }
    --    ),
    --  }
   }
end

-- Servers With Custom Overrides

nvim_lsp.sqlls.setup{
  cmd = {"sql-language-server", "up", "--method", "stdio"},
  on_attach = function(client, bufnr)
    set_lsp_config(client, bufnr)
  end
}

nvim_lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    set_lsp_config(client, bufnr)
  end
} 

-- Custom EFM just for ESLINT
nvim_lsp.efm.setup {
	init_options = {documentFormatting = true},
  on_attach = function(client, bufnr)
    set_lsp_config(client, bufnr)
  end,
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      javascript = {prettier, eslint},
      javascriptreact = {prettier, eslint},
      ["javascript.jsx"] = {prettier, eslint},
      typescript = {prettier, eslint},
      ["typescript.tsx"] = {prettier, eslint},
      typescriptreact = {prettier, eslint},
			yaml = {prettier},
			json = {prettier},
			html = {prettier},
			scss = {prettier},
			css = {prettier},
			markdown = {prettier},
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  },
}
