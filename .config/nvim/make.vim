" A Function that provides a script to automatically call make and see the
" output.
" in short: An improved version of :make

let s:MakeExec = "make"

function Make(...)
	call _Make(s:MakeExec, a:000)
endfunction

function SMake(...)
	call _Make("sudo " . s.MakeExec, a:000)
endfunction

function _Make(exe, args)
	10split
	let args = join(a:args, " ")
	execute "terminal" a:exe args
endfunction

function _MakeC(exe, args)
	let args = split(a:args, " ")
	call _Make(a:exe, args)
endfunction

command! -nargs=* Make call _MakeC(s:MakeExec, "<args>")
command! -nargs=* SMake call _MakeC("sudo " . s:MakeExec, "<args>")

nnoremap <leader>mm :Make<CR>
nnoremap <leader>mc :Make clean<CR>
nnoremap <leader>ma :Make all<CR>
nnoremap <leader>msi :SMake install<CR>

