
-- Uncomment to enable debugging via LspLog
-- vim.lsp.set_log_level("debug")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- Automatically start coq
vim.g.coq_settings = { auto_start = 'shut-up' }

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver', "graphql", "eslint" }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup(require('coq').lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }))
end

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettier,
    },
})


local telescope = require('telescope')
local actions = require('telescope.actions')
local layout = require('telescope.actions.layout')
local moveUp = 
	actions.move_selection_previous
	+ actions.move_selection_previous
	+ actions.move_selection_previous
	+ actions.move_selection_previous

local moveDown = 
	actions.move_selection_next
	+ actions.move_selection_next
	+ actions.move_selection_next
	+ actions.move_selection_next


telescope.setup{
	defaults = {
		mappings = {
			i = {
				["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-p>"] = layout.toggle_preview,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-u>"] = moveUp,
				["<C-d>"] = moveDown,
				["<C-a>"] = actions.toggle_all,
			 },
			n = {
				["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-p>"] = layout.toggle_preview,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-u>"] = moveUp,
				["<C-d>"] = moveDown,
				["<C-a>"] = actions.toggle_all,
			 }
		}
	}
}

