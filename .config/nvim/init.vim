"  _   ___     _____             ___       _ _   
" | \ | \ \   / /_ _|_ __ ___   |_ _|_ __ (_) |_ 
" |  \| |\ \ / / | || '_ ` _ \   | || '_ \| | __|
" | |\  | \ V /  | || | | | | |  | || | | | | |_ 
" |_| \_|  \_/  |___|_| |_| |_| |___|_| |_|_|\__|
                            
" Setup Runtimepath
set runtimepath^=~/.config/vim runtimepath+=~/.config/vim/after
let &packpath = &runtimepath

" Enabale Mouse
set mouse=a

" Source normal vim bindings
source ~/.config/vim/bindings.vim

" Auto copy to Primary, when Selecting
function PrimarySelection()
	" Keep and restore last stored text
	let b = @"
	normal "*ygv
	let @" = b
endfunction
vnoremap <silent> <LeftRelease> <Cmd>call PrimarySelection()<CR>
" Use System Clipboard or Primary Selection
noremap <C-y> "+
noremap <C-y><C-p> "*

" === Source other Scripts ===
source ~/.config/nvim/helperFunctions.vim
source ~/.config/nvim/tagFunctions.vim
source ~/.config/nvim/lineRunner.vim
source ~/.config/nvim/fileFlipper.vim
source ~/.config/nvim/make.vim
source ~/.config/nvim/WhichKeySetup.vim
source ~/.config/nvim/cocSetup.vim

" === Tables ===
function AdjustTable()
	execute "normal vip!column -t -s '|' -o '|'\<CR>"
endfunction
command! AdjustTable call AdjustTable()

" === Terminal ===
let g:lastFilename = ""
function SetLastFilename()
	if expand("%") !~? "term://.*"
		let g:lastFilename = expand("%")
	endif
endfunction

augroup Terminal
	autocmd!
	" Automatically enter insert Mode, when in Terminal
	autocmd BufEnter,TermOpen term://* startinsert
	" Esc in Normal Mode sends Esc to Terminal. (Effectively tap Esc double to send it
	" to the terminal.)
	autocmd BufEnter,TermOpen term://* nnoremap <buffer><nowait> <Esc> i<Esc>
	" Send last filename to terminal
	autocmd BufEnter,TermOpen term://* nnoremap <buffer><nowait> % "=g:lastFilename<CR>p
	autocmd TermOpen * set nonumber norelativenumber
	" Remember last File name
	autocmd BufLeave * call SetLastFilename()
augroup end
" Esc in Terminal Mode brings you back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <M-Up> <C-\><C-n><C-W><Up>
tnoremap <M-Down> <C-\><C-n><C-W><Down>
tnoremap <M-Left> <C-\><C-n><C-W><Left>
tnoremap <M-Right> <C-\><C-n><C-W><Right>
" Shortcut to open terminal in split window
nnoremap <leader>t :15sp +term<CR>
" Add Filename to Terminal
tnoremap <expr> %% g:lastFilename

" Auto Download VimPlug
" if empty(glob('~/.vim/autoload/plug.vim'))
"   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

