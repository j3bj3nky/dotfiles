call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'davidhalter/jedi-vim'
Plug 'neomake/neomake'
Plug 'easymotion/vim-easymotion'
Plug 'thirtythreeforty/lessspace.vim'
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


call plug#end()

colorscheme neonwave

let g:airline_theme = 'deus'
syntax on
filetype indent plugin on
set modeline
