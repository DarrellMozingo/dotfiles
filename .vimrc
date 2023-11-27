set nocompatible              " be iMproved, required
filetype off                  " required
syntax on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'ctrlp.vim'
Plugin 'jshint.vim'
Plugin 'SuperTab'
Plugin 'Syntastic'
Plugin 'The-NERD-tree'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mileszs/ack.vim'

call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"indentation stuff
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" auto reload changes
set autoread

set complete+=k "dictionary autocomplete

set number "view line numbers
highlight LineNr ctermfg=grey

set listchars=tab:▸▸,trail:~ "nicer whitespace chars
set list "show whitespace

"skip backup & swap files
set nobackup
set nowritebackup
set noswapfile
set nomodeline

"toggle nerdtree via F2
:nmap <F2> :NERDTreeToggle<CR>

"save readonly files with sudo using w!!
cmap w!! %!sudo tee > /dev/null %

set exrc "allow per folder configs
set secure "disallow dangerous commands in per folder configs

"close vim if only nerdtree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
