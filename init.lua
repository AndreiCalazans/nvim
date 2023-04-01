-- Lazy.nvim Setup (Plugin)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	"ellisonleao/gruvbox.nvim",
	{
		"dracula/vim",
		lazy = false,
	},
	"nvim-tree/nvim-tree.lua",
	"nvim-tree/nvim-web-devicons",
	"nvim-lualine/lualine.nvim",
	"nvim-treesitter/nvim-treesitter",
	"lewis6991/gitsigns.nvim",
	"christoomey/vim-tmux-navigator",
	"tpope/vim-fugitive",
	-- single/multi line code handler: gS - split one line into multiple, gJ - combine multiple lines into one
	"AndrewRadev/splitjoin.vim",
	-- { "junegunn/fzf.vim",         dependencies = { { dir = vim.env.HOMEBREW_PREFIX .. "/opt/fzf" } } },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Power telescope with FZF
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-rg.nvim",
		},
	},
	{
		"williamboman/mason.nvim",
		config = true,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			-- Helpers to install LSPs and maintain them
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	}, -- neovim completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			-- show treesitter nodes
			"nvim-treesitter/playground", -- enable more advanced treesitter-aware text objects
			"nvim-treesitter/nvim-treesitter-textobjects", -- add rainbow highlighting to parens and brackets
			"p00f/nvim-ts-rainbow",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{ "stevearc/dressing.nvim", event = "VeryLazy" }, -- Navigate a code base with a really slick UI
	"folke/neodev.nvim", -- for autocompletion in Lua in the config files
	{
		"folke/trouble.nvim",
		config = true,
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
			{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>" },
		},
	},
	"glepnir/lspsaga.nvim",
	"danilamihailov/beacon.nvim",
	"tpope/vim-commentary",
	"github/copilot.vim",
	{
		"dpayne/CodeGPT.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
}

local opts = {}

require("lazy").setup(plugins, opts)

local CodeGPTModule = require("codegpt")
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "dracula",
	},
	sections = {
		lualine_a = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_b = { "branch", "diff", "diagnostics", CodeGPTModule.get_status },
		lualine_c = {},
	},
})

-- Options
vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.autoindent = true
vim.opt.showmatch = true -- show matching braces
vim.opt.ttyfast = true -- faster redrawing

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.scrolloff = 999 -- center scroll
vim.opt.textwidth = 80
vim.opt.backspace = { "indent", "eol,start" } -- make backspace behave in a sane manner
vim.opt.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
vim.opt.mouse = "a" -- set mouse mode to all modes

vim.opt.foldmethod = "indent"
-- default to zero folds when opening a file (zc to trigger folds)
vim.opt.foldenable = false

-- searching
vim.opt.ignorecase = true -- case insensitive searching
vim.opt.smartcase = true -- case-sensitive if expresson contains a capital letter
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- set incremental search, like modern browsers
vim.opt.lazyredraw = false -- don't redraw while executing macros

vim.cmd([[set noswapfile]])

-- Appearence
vim.o.termguicolors = true
vim.cmd([[colorscheme gruvbox]])

--Line numbers
vim.wo.number = true
vim.wo.colorcolumn = 80

-- Key bindings

vim.keymap.set("n", ",<space>", ":nohlsearch<CR>") -- unselect highlighted
vim.keymap.set("n", ",gs", ":Git<CR>") -- show git status
vim.keymap.set("n", ",gb", ":Git blame<CR>") -- open git blame
vim.keymap.set("n", ",d", ":bd<CR>") -- close buffer
vim.keymap.set("n", ",a", ":b#<CR>") -- switch to alternate file #
vim.keymap.set("n", "-", ":Explore<CR><CR>") -- Open file browser
vim.keymap.set("n", ",p", function()
	vim.lsp.buf.format({
		timeout_ms = 2000,
		filter = function(client)
			return client.name == "null-ls"
		end,
	})
end) -- format buffer
