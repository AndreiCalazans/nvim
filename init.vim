
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'windwp/nvim-autopairs'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

Plug 'lunarvim/colorschemes'


" Telescope deps
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'jose-elias-alvarez/null-ls.nvim'

call plug#end()

" NeoVim's LSP Set UP
lua require("lsp_config")

let mapleader=','
nnoremap <silent>- :Explore<CR>
nnoremap <silent> <leader><space> :noh<cr>

"" Git
noremap <Leader>gs :Git<CR>
noremap <Leader>gb :Git blame<CR>

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" Find files using Telescope command-line sugar.
nnoremap <leader>e <cmd>Telescope find_files previewer=false<cr>
nnoremap <leader>f <cmd>Telescope live_grep previewer=false<cr>
nnoremap <leader>b <cmd>Telescope buffers previewer=false<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>Y <cmd>Telescope command_history<cr>
nnoremap <leader>y <cmd>Telescope oldfiles<cr>
nnoremap <leader>j <cmd>Telescope jumplist<cr>

nnoremap <leader>c :bd<cr>
nnoremap <leader>n :set nu<cr> " Show numbers
nnoremap <leader>N :set nonu<cr> " Hide numbers

nnoremap <leader>D :lua vim.diagnostic.config({virtual_text = false})<cr>
nnoremap <leader>d :lua vim.diagnostic.config({virtual_text = true})<cr>

set tabstop=2
set shiftwidth=2
" Don't show error column on the right since it is redundant
set signcolumn=no

" Show line
set cursorline 

" Allow switching buffers that are not yet saved
set hidden

colorscheme system76
