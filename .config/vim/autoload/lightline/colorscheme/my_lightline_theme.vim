" My Fork of the One Theme for Lightline which makes use of the 16-Colors,
" provided by the terminal.

" Load values from used colorscheme:
" TODO: Change to custom script? Maybe?
source ~/build/termcolors/out/colors-wal.vim

" Common colors
let s:blue   = [ g:color12, 12 ]
let s:green  = [ g:color10, 10 ]
let s:purple = [ g:color5,   5 ]
let s:red1   = [ g:color1,   1 ]
let s:red2   = [ g:color9,   9 ]
let s:yellow = [ g:color11, 11 ]

" Dark variant
let s:fg    = [ g:color15, 145 ] " Middle + Second Row FG
let s:bg    = [ g:color0,  235 ] " First Row FG
let s:gray1 = [ g:color7,  241 ] " Inactive FG
let s:gray2 = [ g:color8,  235 ] " Middle Row BG
let s:gray3 = [ g:color0,  240 ] " Second Row BG
let s:noneColor = [ "None", "None" ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

" Middle Row
let s:p.normal.middle  = [ [ s:fg, s:gray2 ] ]
" Second Row
let s:second_row = [ s:fg, s:gray3 ]

" Common
let s:p.normal.left    = [ [ s:bg, s:green, 'bold' ], s:second_row ]
let s:p.normal.right   = [ [ s:bg, s:green, 'bold' ], s:second_row ]
let s:p.normal.error   = [ [ s:red2, s:bg ] ]
let s:p.normal.warning = [ [ s:yellow, s:bg ] ]
let s:p.insert.right   = [ [ s:bg, s:blue, 'bold' ], s:second_row ]
let s:p.insert.left    = [ [ s:bg, s:blue, 'bold' ], s:second_row ]
let s:p.replace.right  = [ [ s:bg, s:red1, 'bold' ], s:second_row ]
let s:p.replace.left   = [ [ s:bg, s:red1, 'bold' ], s:second_row ]
let s:p.visual.right   = [ [ s:bg, s:purple, 'bold' ], s:second_row ]
let s:p.visual.left    = [ [ s:bg, s:purple, 'bold' ], s:second_row ]

" Inactive
let s:p.inactive.left   = [ [ s:gray1,  s:bg ], [ s:gray1, s:gray3 ] ]
let s:p.inactive.middle = [ [ s:gray1, s:gray2 ] ]
let s:p.inactive.right  = [ [ s:gray1, s:bg ] ]

" Tabline
let s:p.tabline.left   = [ [ s:fg, s:gray3 ] ]
let s:p.tabline.tabsel = [ [ s:bg, s:purple, 'bold' ] ]
let s:p.tabline.middle = [ [ s:gray3, s:gray2 ] ]
let s:p.tabline.right  = copy(s:p.normal.right)

let g:lightline#colorscheme#my_lightline_theme#palette = lightline#colorscheme#flatten(s:p)
