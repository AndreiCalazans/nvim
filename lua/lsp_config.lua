
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

  -- Turning off formating
   client.server_capabilities.document_formatting = false

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
  -- vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end


local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
	}, {
		{ name = 'buffer' },
	})
})

  -- Setup lspconfig.
-- cmp_nvim_lsp.default_capabilities
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "tsserver", "eslint" }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup({
		debounce_text_changes = 200,
		on_attach = on_attach,
		capabilities = require('cmp_nvim_lsp').default_capabilities(),
		  diagnostics = {
				enable = true,
				run_on = "type", -- or `save`
		},
	})
end


-- local null_ls = require("null-ls")
-- null_ls.setup({
--   on_attach = function(client, bufnr)
--     if client.server_capabilities.documentFormattingProvider then
--       vim.cmd("nnoremap <silent><buffer> <space>f :lua vim.lsp.buf.format()<CR>")

--       -- format on save
--       -- vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.format()")
--     end
--   end,
-- })

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
        ["j"] = actions.cycle_history_next,
        ["k"] = actions.cycle_history_prev,
			 }
		}
	}
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	 vim.lsp.diagnostic.on_publish_diagnostics, {
		 -- Enable underline, use default values
		 underline = true,
		 -- Disable a feature
		 update_in_insert = false,
	 }
 )


require("nvim-autopairs").setup {}

require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  }
}


local builtin = require("telescope.builtin")

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>F", builtin.resume, opts)
vim.keymap.set("n", "<leader>H", builtin.search_history, opts)
