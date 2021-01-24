"        _                    
" __   _(_)_ __ ___  _ __ ___ 
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__ 
"   \_/ |_|_| |_| |_|_|  \___|

set nocompatible

" Setup Runtimepath
set runtimepath^=~/.config/vim runtimepath+=~/.config/vim/after
let &packpath = &runtimepath

source ~/.config/vim/bindings.vim

" Enable Command Mode Completion
set wildmenu

" Search Highlight
set hlsearch
set incsearch

" Remove this dumm bell
set visualbell
set t_vb=

" Auto Download VimPlug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

