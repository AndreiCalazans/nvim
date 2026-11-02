local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- ktlint reads the repo .editorconfig (indent 4, max_line_length 140).
    kotlin = { "ktlint" },
    -- Apple's swift-format ships with Xcode; reached through xcrun.
    swift = { "swift_format" },
    lua = { "lua_ls" },
  },
  formatters = {
    ktlint = {
      command = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/ktlint"),
      -- --format edits stdin in place; --stdin reads the buffer; log level quiet.
      args = { "--format", "--stdin", "--log-level=none" },
      stdin = true,
      -- ktlint exits non-zero when it had to fix things; still trust its output.
      exit_codes = { 0, 1 },
    },
    swift_format = {
      -- Apple's swift-format (ships with Xcode). `-` reads stdin; --assume-filename
      -- lets it discover the nearest repo .swift-format config for the file.
      command = "xcrun",
      args = { "swift-format", "format", "--assume-filename", "$FILENAME", "-" },
      stdin = true,
    },
  },
})

-- ,p formats via conform (ktlint/swift-format), falling back to the LSP for
-- filetypes conform has no formatter for (ts/go/etc use their LSP as before).
vim.keymap.set("n", ",p", function()
  conform.format({ async = false, lsp_fallback = true })
end, { desc = "Format buffer (conform -> LSP fallback)" })
