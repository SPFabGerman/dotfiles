" This File keeps all the utilities for working with tags.

" === Tag Jump ===
" This Function can be used to jump to a tag in a file.
function TagJump()
	let filename = expand('%')

	function! s:TagJump_Callback(status, lines)
		if a:status == 0
			let line = a:lines[0]
			execute line
			normal zt
		endif
	endfunction

	let exec = '~/.config/nvim/tagLineSelector.sh "' . filename . '"'
	call OpenFZF({'fzf_exec':exec, 'Callback':function("s:TagJump_Callback")})
endfunction

nnoremap ,j :call TagJump()<CR>


" === Tag Generation ===
" This function generates the tags.vim file and highlights all tags.
function TagsGenerate(runCtags)
	" Generate Tags File, if it doesn't exists
	if (!filereadable("tags") || a:runCtags == 1)
		!ctags %
	endif

	sp tags

	" Remove Comments etc.
	g/^!.*$/d
	g/^__anon.*$/d
	%s/^\([^	:]*:\)\=// "Required?
	%s/^\([^	]*\).*\/;"	\(.\).*/syntax keyword Tag_\2 \1/
	
	wq! tags.vim
	
	call TagsHighlight()
endfunction

" This Function enables the Highlighting of all the Tags
" (tags.vim must be present)
function TagsHighlight()
	augroup taghighlight
		autocmd!
		" Automatically highlight tags for every newly opened file
		autocmd BufRead * source tags.vim
	augroup END
	source tags.vim
endfunction

nnoremap <leader>T :silent call TagsGenerate(0)<CR>

" Automatically start Highlighting Tags, if Tag file exists.
if filereadable("tags.vim")
	silent call TagsHighlight()
endif


" === Auto Highlight, without tag file ===
function AutoHighlight()
	let autoHighlightOpt = { 'stdout_buffered' : v:true }
	function! autoHighlightOpt.on_stdout(id, data, name)
		for line in a:data
			execute line
		endfor
	endfunction

	call jobstart('~/.config/nvim/tagGenerator.sh ' . expand('%'), autoHighlightOpt)
endfunction

augroup taghighlight2
	autocmd!
augroup END

