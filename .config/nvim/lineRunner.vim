" This File can defines functions and keybindings to load and run vimscript
" and keychords directly from a file.

" TODO: Add Function to only run commands beginning from Cursor.

" This function can be used to run a command that is on the current line.
" To ignore Comments in Files only everything after ':' is interpreted as a
" command.
function ExecuteLine()
	let line = getline('.')
	let line = matchstr(line, ':.*$')
	let line = strpart(line, 1)
	" call execute(line, "")
	execute line
endfunction
command! LineExec call ExecuteLine()
nnoremap <leader>le :LineExec<CR>
" This is a template Text :echo "Test sucessfully."

" This function can be used to simulate key presses on the line.
" Everything after the first '.' is interpreted as a key to press.
" You can use <...> Key Codes normally. ( '<' is a special character. To type
" a literal '<' use '<LT>'.)
function TypeLine()
	let line = getline('.')
	let line = matchstr(line, '\..*$')
	let line = strpart(line, 1)
	call nvim_input(line)
endfunction
command! LineType call TypeLine()
nnoremap <leader>lk :LineType<CR>
" This is another template for key presses: .oHello <Esc>iWorld<Esc>:echo "Hello 1" | echo "Hello 2"

" This function calls either the TypeLineSafe or ExecuteLine
" function, depending on wether ':' or '.' appeared first in the line.
function ExecTypeLine()
	let line = getline('.')
	let i1 = match(line, '\.')
	let i2 = match(line, ':')
	if ( (i1 != -1) && ((i1 < i2) || (i2 == -1)) )
		call TypeLine()
	elseif ( (i2 != -1) && ((i2 < i1) || (i1 == -1)) )
		call ExecuteLine()
	endif
endfunction
command! LineRun call ExecTypeLine()
nnoremap <leader>ll :LineRun<CR>
" :echo "Test" . " 1"
" .oTest: 2<esc>

