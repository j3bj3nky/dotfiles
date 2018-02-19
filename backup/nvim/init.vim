call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'davidhalter/jedi-vim'
Plug 'neomake/neomake'
Plug 'thirtythreeforty/lessspace.vim'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'vim-syntastic/syntastic'
Plug 'bfredl/nvim-ipy'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'rust-lang/rust.vim'
Plug 'challenger-deep-theme/vim'
Plug 'cjrh/vim-conda'
Plug 'w0ng/vim-hybrid'
Plug 'stayradiated/vim-termorrow'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'Valloric/YouCompleteMe'
Plug 'ternjs/tern_for_vim'
Plug 'chriskempson/base16-vim'

call plug#end()

" NORMAL SETTINGS
" line numbers
set number relativenumber

set path+=**

set wildmenu

" I forgot
filetype indent plugin on

" modeline is on
set modeline

" syntax on
syntax on

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za


" PLUGIN SETTINGS
" colorscheme
colorscheme base16-default-dark

" lessspace no startup
let g:lessspace_enabled = 0

" lightline theme
let g:lightline = { 'colorscheme': 'jellybeans'}
set noshowmode

" true colors
if has('nvim') || has('termguicolors')
  set termguicolors
endif

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ipy mappings
let g:nvim_ipy_perform_mappings = 0

" fastfold
let g:fastfold_savehook = 0

" hybrid color
" set background=dark
" let g:hybrid_custom_term_colors = 1
" colorscheme termorrow
