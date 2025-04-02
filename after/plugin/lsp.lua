local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

require("lspsaga").setup({
  code_action_icon = "",
  lightbulb = { enable = false },
  symbol_in_winbar = {
    in_custom = false,
    enable = true,
    separator = " ",
    show_file = true,
    file_formatter = "wat",
  },
})

local opts = { silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
vim.keymap.set("n", "go", "<cmd>Lspsaga outline<CR>", opts)
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<cr>", opts)
vim.keymap.set({ "n", "v" }, ",ca", "<cmd>Lspsaga code_action<CR>", opts)

require("neodev").setup()

require("mason").setup()

-- a0c4dc1 feat!: removing `setup_handlers` function. automatic_setup is now implicitly true. (#59) (3 days ago)
mason_lspconfig.setup({
  ensure_installed = {
    -- Opt to list sources here, when available in mason.
  },
  automatic_installation = false,
  automatic_setup = true, -- Recommended, but optional
})

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
    },
  },
})

lspconfig.denols.setup {
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false
})

lspconfig.eslint.setup({
  capabilities = capabilities,
})

lspconfig.elixirls.setup({
  capabilities = capabilities,
})

lspconfig.gopls.setup({
  capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
})

lspconfig.astro.setup({
  capabilities = capabilities,
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "rust", "javascript", "typescript", "markdown", "markdown_inline", "vim", "astro", "go", "cpp", "c" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})

vim.diagnostic.config({
  virtual_text = false,
})
