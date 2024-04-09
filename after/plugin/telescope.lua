local telescope = require("telescope")
local actions = require("telescope.actions")
local layout = require("telescope.actions.layout")

local moveUp = actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous
    + actions.move_selection_previous

local moveDown = actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next
    + actions.move_selection_next

telescope.setup({
  pickers = {
    find_files = {
      hidden = true
    },
    live_grep = {
      hidden = true
    }
  },
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
      },
    },
  },
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", ",e", builtin.find_files, {})
vim.keymap.set("n", ",E", builtin.oldfiles, {})
vim.keymap.set("n", ",f", builtin.live_grep, {})
vim.keymap.set("n", ",b", builtin.buffers, {})
vim.keymap.set("n", ",Y", builtin.command_history, {})
vim.keymap.set("n", ",j", builtin.jumplist, {})
