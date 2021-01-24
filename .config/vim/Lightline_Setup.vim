" Setup for Lightline

" always show Lightline Status Bar
set laststatus=2
set showtabline=2

" disable extra INSERT Message
set noshowmode

" add Color Scheme and extra Stuff
let g:lightline = {
	\ 'colorscheme': 'my_lightline_theme',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste', 'recording' ],
	\             [ 'readonly', 'modified', 'filename', 'dir' ],
	\             [ 'cwd' ] ],
	\   'right': [ [ 'lineinfo' ], 
	\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
	\ },
	\ 'inactive': {
	\   'left': [ [ 'winnr' ], [ 'readonly', 'modified', 'filename', 'dir' ],
	\             [] ],
	\   'right': [ [ 'lineinfo' ],
	\              [ 'filetype' ] ]
	\ },
	\ 'tabline': {
	\   'left': [['buffers']],
	\   'right': [['close']]
	\ },
	\ 'tab': {
	\   'active': [ 'tabnum', 'subsep', 'filename' ],
	\   'inactive': [ 'tabnum', 'subsep','filename' ]
	\ },
	\ 'component': {
	\   'trimright': '%<',
	\   'charvaluehex': '0x%B',
	\ },
	\ 'tab_component': {
	\   'subsep': "\uE0B1"
	\ },
	\ 'component_function': {
	\   'filetype': 'LightlineFiletype',
	\   'dir': 'LightlineDir',
	\   'cwd': 'LightlineCWD',
	\   'readonly': 'LightlineReadonly',
	\   'modified': 'LightlineModified',
	\   'fileformat': 'LightlineFileformat',
	\   'fileencoding': 'LightlineFileencoding',
	\   'lineinfo': 'LightlineLineinfo',
	\   'lineinfoVisible': 'LightlineLineinfoVisible',
	\   'percent': 'LightlinePercentage',
	\   'recording': 'LightlineRecording',
	\ },
	\ 'component_expand': {
	\   'buffers': 'lightline#bufferline#buffers'
	\ },
	\ 'component_type': {
	\   'buffers': 'tabsel'
	\ },
	\ 'component_raw': { 'buffers': 1 }
	\ }

let g:hide_width = 90
let g:hide_width_2 = 70

" A simple Helper functions that returns true if the window should generally
" be excluded from lightline information.
function WindowExcluded()
	if &filetype =~# '\v(help|nerdtree)' || expand('%') =~# '^term://'
		return v:true
	endif
	return v:false
endfunction

function LightlineFiletype()
	if WindowExcluded()
		return ''
	endif

	let sym = WebDevIconsGetFileTypeSymbol()
	" return &filetype !=# '' ? ( sym . ' ' . &filetype ) : 'no ft'
	return winwidth(0) > g:hide_width_2 ? (&filetype !=# '' ? ( sym . ' ' . &filetype ) : 'no ft') : ''
endfunction

function LightlineDir()
	if WindowExcluded()
		return ''
	endif

	" Show rel. Dir of File, if it differs from the CWD
	let dir = expand('%:h') !=# '.' && expand('%:h') !=# getcwd() ? expand('%:h') . '/' : ''
	return winwidth(0) > g:hide_width_2 ? dir : ''
endfunction

function LightlineCWD()
	" Show Folder Name of CWD
	return winwidth(0) > g:hide_width ? fnamemodify(getcwd(),":t") : ''
endfunction

function LightlineReadonly()
	return (&readonly || !&modifiable) && !WindowExcluded() ? '' : ''
endfunction

function LightlineModified()
	return &modified ? '+' : ''
endfunction

function LightlineFileformat()
	return &fileformat == "unix" ? '' : &fileformat
	" return winwidth(0) > g:hide_width ? &fileformat : ''
endfunction

function LightlineFileencoding()
	return &fileencoding == "utf-8" ? '' : &fileencoding
	" return winwidth(0) > g:hide_width ? &encoding : ''
endfunction

function LightlineLineinfo()
	if WindowExcluded()
		return ''
	endif
	" let cn = winwidth(0) > g:hide_width ? ('' . col(".")) : ''
	let ln = '' . line(".") . '/' . line("$")
	return ln
	" return ln . cn
endfunction

function LightlineLineinfoVisible()
	if WindowExcluded()
		return ''
	endif

	let ln = winwidth(0) > g:hide_width ? ('' . line("w0") . '-' . line("w$")) : ''
	return ln
endfunction

function LightlinePercentage()
	if WindowExcluded()
		return ''
	endif
	return winwidth(0) > g:hide_width ? (line('.') * 100 / line('$') . '%') : ''
endfunction

function LightlineRecording()
	let l = reg_recording()
	return l == "" ? '' : (' ' . l)
endfunction

" Make cooler Seperators
let g:lightline.separator = {
	\   'left': '', 'right': ''
	\}
let g:lightline.subseparator = {
	\   'left': '\uE0B1', 'right': '\uE0B1' 
	\}
let g:lightline.tabline_separator = g:lightline.separator
let g:lightline.tabline_subseparator = g:lightline.subseparator

" Mode Names
let g:lightline.mode_map = {
	\ 'n'     : 'NORMAL',
	\ 'c'     : '  CMD ',
	\ 'i'     : 'INSERT',
	\ 't'     : ' TERM ',
	\ 'R'     : 'RPLACE',
	\ 'v'     : 'VISUAL',
	\ 'V'     : 'V LINE',
	\ "\<C-v>": 'V  BLK',
	\ 's'     : 'SELECT',
	\ 'S'     : 'S LINE',
	\ "\<C-s>": 'S  BLK',
	\ }

let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#min_buffer_count = 2

