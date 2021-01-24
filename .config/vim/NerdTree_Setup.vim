" Config to be used together with NerdTree

" auto open / close vim
augroup NERDOpenClose
	autocmd!
    " Auto Close
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " Auto Open
	" autocmd vimenter * NERDTree | wincmd l
    " Cursorline inverse in NERDTree
    au BufEnter * if (buffer_name("%") == "NERD_tree_1") | set cursorline | hi CursorLine cterm=inverse | endif
    au BufLeave * set nocursorline
augroup END

let NERDTreeMinimalUI = 1
hi! link NERDTreeFlags NERDTreeDir
hi link NERDTreeDirSlash NERDTreeDir
" hi link NERDTreeCWD NERDTreeDir
hi NERDTreeCWD ctermfg=darkyellow cterm=underline
hi NERDTreeFile ctermfg=lightblue
hi NERDTreeOpenable ctermfg=yellow
hi link NERDTreeClosable NERDTreeOpenable 
hi NERDTreeExecFile ctermfg=magenta
let g:DevIconsEnableFoldersOpenClose = 1

