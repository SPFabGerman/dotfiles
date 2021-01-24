" A Script that can be used to replace the text with an expression.

" TODO: Test if String is number.
function ChangeNumber()
	try
		let n = expand("<cword>")
		let n2 = input("=", n . "+")
		let n3 = eval(n2)
	catch
		echo "Error when changing number:"
	endtry
	execute "normal" "ciw".string(n3)."\<Esc>"
endfunction


" nnoremap + "mdiwa<C-R>=<C-R>m+
nnoremap + :call ChangeNumber()<CR>
" 10

