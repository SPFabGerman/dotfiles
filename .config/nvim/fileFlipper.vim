" This File provides Function to change between Files fast (with Shift Up and
" Shift Down Keys.)

function FileFlipper(backwards)
	let filename = expand("%")

	let opt = { 'stdout_buffered' : v:true }
	function opt.on_stdout(id, data, name)
		let newname = a:data[0]
		" echo "File: " . newname
		if newname == ''
			return
		elseif bufexists(newname)
			execute "buffer" newname
		else
			execute "edit" newname
		endif
	endfunction
	
	let arg = a:backwards ? '' : 'r'

	let id = jobstart("ls -A".arg." | sed -n -e '/".filename."/q;p' | tail -1", opt)
endfunction

function FileNext()
	call FileFlipper(v:false)
endfunction
function FilePrev()
	call FileFlipper(v:true)
endfunction

command! FileNext call FileNext()
command! FilePrev call FilePrev()

nnoremap <S-Down> :FileNext<CR>
nnoremap <S-Up> :FilePrev<CR>

