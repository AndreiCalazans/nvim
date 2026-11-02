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
vim.lsp.enable("lua_ls")

-- vim.lsp.config("ts_ls", {
--   single_file_support = false,
--   root_markers = { ".git" },
-- })
--
-- vim.lsp.enable("ts_ls")
--
vim.lsp.config("eslint", {
  capabilities = capabilities,
})
vim.lsp.enable("eslint")

vim.lsp.config("gopls", {
  capabilities = capabilities,
})
vim.lsp.enable("gopls")

require("nvim-treesitter.config").setup({
  ensure_installed = { "c", "lua", "rust", "javascript", "typescript", "markdown", "markdown_inline", "vim", "astro", "go", "cpp", "kotlin", "swift" },
  ignore_install = {},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})

vim.lsp.config("ts_go_ls", {
  cmd = { vim.fn.expand("$HOME/.local/share/nvim/mason/bin/tsgo"), "--lsp", "-stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  capabilities = {
    documentFormattingProvider = false,
    documentRangeFormattingProvider = false,
  },
})

vim.lsp.enable("ts_go_ls")

-- Resolves commonMain + JVM/Android source sets from the Gradle classpath;
-- run `./gradlew build` once so the classpath cache exists. iOS/native source
-- sets stay weak - keep IntelliJ/Xcode for those halves.
vim.lsp.config("kotlin-lsp", {
  capabilities = capabilities,
  root_markers = { "settings.gradle.kts", "settings.gradle", "build.gradle.kts", "build.gradle", ".git" },
  settings = {
    kotlin = {
      -- ktlint/detekt own formatting for this repo; let conform + ktlint format.
      formatting = { formatter = "none" },
    },
  },
})
vim.lsp.enable("kotlin-lsp")

-- Swift / C-family via the Xcode-shipped SourceKit-LSP.
-- For SPM packages it reads Package.swift directly; for the Tuist/xcodeproj
-- app targets, generate a compile database so cross-file indexing works
-- (see `xcode-build-server` note in the setup summary).
vim.lsp.config("sourcekit", {
  capabilities = capabilities,
  cmd = { "xcrun", "sourcekit-lsp" },
  filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
  root_markers = { "Package.swift", "MobileSkunkworks.xcworkspace", "Workspace.swift", ".git" },
})
vim.lsp.enable("sourcekit")
