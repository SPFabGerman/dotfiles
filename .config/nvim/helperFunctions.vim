" This Function generates a Floating Window with a Border.
" You can create another Floating Window afterwards, that will fit inside the
" Border perfectly.
" It adjusts winopt.width/height/row/col and sets focusable to true, so the
" Object can be reused to create the new Floating Window.
" Returns the Buffer Number of the Floating Window, so that it can be closed.
function GenerateFloatingBorder(winopt)
	let top = "╭" . repeat("─", a:winopt.width - 2) . "╮"
	let mid = "│" . repeat(" ", a:winopt.width - 2) . "│"
	let bot = "╰" . repeat("─", a:winopt.width - 2) . "╯"
	let lines = [top] + repeat([mid], a:winopt.height - 2) + [bot]

	let linebuf = nvim_create_buf(0, 1)
	call nvim_buf_set_lines(linebuf, 0, -1, 1, lines)
	let a:winopt.focusable = 0
	let linewin = nvim_open_win(linebuf, 0, a:winopt)

	let a:winopt.width -= 2
	let a:winopt.height -= 2
	let a:winopt.row += 1
	let a:winopt.col += 1
	let a:winopt.focusable = 1

	return linebuf
endfunction

" This Function can be called to automatically create a floating fzf window.
" The Argument is a dictionary containing the following entries:
" - fzf_exec: [Optional, String] overwrites the fzf Executeable. Can be used to pass Arguments to FZF.
"   (Do not redirect the output in the String!)
"   Defaults to: "fzf --border"
" - lines: [Optional, List] The Lines to be displayed by fzf.
"   These are passed directly to the Executable.
" - Callback: [Mandatory, Function(status, lines)] The Function to be called after fzf finished.
"   Gets the Exit Status and a List of all selected Items.
"   (Use Index 0 if you don't use multiselect and want to retrieve the item.)
function OpenFZF(opt)
	" Work trough arguments.
	if has_key(a:opt, 'fzf_exec')
		let fzf_exec = a:opt.fzf_exec
	else
		let fzf_exec = 'fzf --border'
	endif
	if has_key(a:opt, 'lines')
		let input_lines = a:opt.lines
		let input_avail = 1
	else
		let input_avail = 0
	endif
	if has_key(a:opt, 'Callback')
		let CallbackFunc = a:opt.Callback
	else
		echo "No Callback Function specified."
		return
	endif

	" Generate a temp file (and strip the newline of the cmd output)
	" Needed, since on_stdout function is bit buggy with fzf.
	let outfile = systemlist('mktemp')[0]

	let width = winwidth(0)
	let height = winheight(0)

	let winopt = {'relative':'win', 'width':width-8, 'height':height-6, 'row':3, 'col':4, 'style':'minimal'}

	" Open New Buffer and Floating Window
	let buffer = nvim_create_buf(0, 0)
	let window = nvim_open_win(buffer, 1, winopt)

	let termopt = { 'outfile': outfile, 'buffer': buffer, 'window': window, 'CallbackFunc': CallbackFunc }
	function termopt.on_exit(id, status, event)
		" Exit Terminal Window and close all Buffers
		if expand('%') =~# '^term://'
			let bn = bufnr()
			quit
			execute "bwipeout!" string(bn)
		endif

		let lines = readfile(self.outfile)
		" Remove temp file
		call delete(self.outfile)

		call self.CallbackFunc(a:status, lines)
	endfunction

	" Start Terminal and enter Insert Mode (and overwrite Esc Mapping)
	if input_avail
		let id = termopen('cat | ' . fzf_exec . ' > ' . outfile, termopt)
		" Send all Lines and end with newline (to stop cat)
		call chansend(id, input_lines + ["\<C-D>"])
	else
		call termopen(fzf_exec . ' > ' . outfile, termopt)
	endif

	tnoremap <buffer> <Esc> <Esc>
	startinsert
endfunction

