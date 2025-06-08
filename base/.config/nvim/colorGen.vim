" This file generates a color array and some functions to help select colors,
" such that the GUI Color is identical to the 16-Color RGB Values.

" Load values from used colorscheme:
source ~/.cache/wal-term/colors-wal.vim

" create Color Array:
let guicolors = []
call add(guicolors, color0)
call add(guicolors, color1)
call add(guicolors, color2)
call add(guicolors, color3)
call add(guicolors, color4)
call add(guicolors, color5)
call add(guicolors, color6)
call add(guicolors, color7)
call add(guicolors, color8)
call add(guicolors, color9)
call add(guicolors, color10)
call add(guicolors, color11)
call add(guicolors, color12)
call add(guicolors, color13)
call add(guicolors, color14)
call add(guicolors, color15)
call add(guicolors, "None")

function GUIHighlight(name, fg, bg, feature)
	let f = g:guicolors[a:fg]
	if (f == "None")
		let f_c = "None"
	else
		let f_c = a:fg
	endif
	let b = g:guicolors[a:bg]
	if (b == "None")
		let b_c = "None"
	else
		let b_c = a:bg
	endif
	execute "highlight" a:name "ctermfg=".f_c "guifg=".f "ctermbg=".b_c "guibg=".b "cterm=".a:feature "gui=".a:feature
endfunction

function HighlightLink(orig, dest)
	execute "highlight" a:orig "NONE"
	execute "highlight link" a:orig a:dest
endfunction

let black=0
let darkred=1
let darkgreen=2
let darkyellow=3
let darkblue=4
let darkmagenta=5
let darkcyan=6
let lightgrey=7
let darkgrey=8
let lightred=9
let lightgreen=10
let lightyellow=11
let lightblue=12
let lightmagenta=13
let lightcyan=14
let white=15

let g:terminal_color_0 = color0
let g:terminal_color_1 = color1
let g:terminal_color_2 = color2
let g:terminal_color_3 = color3
let g:terminal_color_4 = color4
let g:terminal_color_5 = color5
let g:terminal_color_6 = color6
let g:terminal_color_7 = color7
let g:terminal_color_8 = color8
let g:terminal_color_9 = color9
let g:terminal_color_10 = color10
let g:terminal_color_11 = color11
let g:terminal_color_12 = color12
let g:terminal_color_13 = color13
let g:terminal_color_14 = color14
let g:terminal_color_15 = color15

