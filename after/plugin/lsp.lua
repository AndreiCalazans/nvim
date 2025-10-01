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

local function nextDiagnostic()
  vim.diagnostic.jump({ count = 1, float = true })
end

local function prevDiagnostic()
  vim.diagnostic.jump({ count = -1, float = true })
end

local opts = { silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", prevDiagnostic, opts)
vim.keymap.set("n", "]d", nextDiagnostic, opts)
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
  automatic_enable = false,
})

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.config("lua_ls", {
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

vim.lsp.enable("ts_ls")

vim.lsp.config("eslint", {
  capabilities = capabilities,
})

vim.lsp.config("gopls", {
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

-- Current disabled ts go because it bricks my CPU.
-- vim.diagnostic.config({
--   virtual_text = false,
-- })
-- vim.lsp.config("ts_go_ls", {
--     cmd = { "bun", "tsgo", "--lsp", "-stdio" },
--     filetypes = {
--         "javascript",
--         "javascriptreact",
--         "javascript.jsx",
--         "typescript",
--         "typescriptreact",
--         "typescript.tsx",
--     },
--     root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
-- })
-- vim.lsp.enable("ts_go_ls")
