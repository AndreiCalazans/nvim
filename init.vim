
call plug#begin()

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

" Telescope deps
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'MunifTanjim/prettier.nvim'

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

" Prettier
" range_formatting in visual mode
xmap <Leader>P <Plug>(prettier-format)
" formatting in normal mode
nmap <Leader>p <Plug>(prettier-format)

" Find files using Telescope command-line sugar.
nnoremap <leader>e <cmd>Telescope find_files<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>
nnoremap <leader>Y <cmd>Telescope command_history<cr>
nnoremap <leader>y <cmd>Telescope oldfiles<cr>


