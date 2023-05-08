local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local mason_null_ls = require("mason-null-ls")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local group = vim.api.nvim_create_augroup("LspConfig", { clear = true })
local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local null_ls = require("null-ls")

require("lspsaga").setup({
  code_action_icon = "💡",
  symbol_in_winbar = {
    in_custom = false,
    enable = true,
    separator = " ",
    show_file = true,
    file_formatter = "",
  },
})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

vim.keymap.set("n", "gd", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<cr>", { silent = true })
vim.keymap.set({ "n", "v" }, ",ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })

require("neodev").setup()

require("mason").setup()

mason_null_ls.setup({
  ensure_installed = {},
  automatic_installation = false,
  automatic_setup = true, -- Recommended, but optional
  handlers = {
    prettier = function()
      null_ls.register(null_ls.builtins.formatting.prettier.with({
        filetypes = {
          "astro",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "css",
          "scss",
          "json",
          "graphql",
          "markdown",
          "yaml",
          "html",
          "vue",
          "svelte",
          "lua",
        },
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
      }))
    end,
  }
})

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
      -- vim.api.nvim_create_autocmd("BufWritePre", {
      --   group = vim.api.nvim_create_augroup("LspFormatting", {}),
      --   buffer = bufnr,
      --   callback = function()
      --     vim.lsp.buf.format({ bufnr = bufnr })
      --   end,
      -- })
    end
  end,
})

        -- a0c4dc1 feat!: removing `setup_handlers` function. automatic_setup is now implicitly true. (#59) (3 days ago)
mason_lspconfig.setup({
  ensure_installed = {
    -- Opt to list sources here, when available in mason.
  },
  automatic_installation = false,
  automatic_setup = true, -- Recommended, but optional
})

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig").lua_ls.setup({
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
    },
  },
})

require("lspconfig").tsserver.setup({
  capabilities = capabilities,
})

require("lspconfig").eslint.setup({
  capabilities = capabilities,
})

require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "javascript", "typescript", "markdown", "markdown_inline", "vim" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})

vim.diagnostic.config({
  virtual_text = false,
})
