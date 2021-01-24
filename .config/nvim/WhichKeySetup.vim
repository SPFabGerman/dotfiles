" === Basic Config ===
let g:which_key_use_floating_win = 0
let g:which_key_disable_default_offset = 1
" let g:which_key_fallback_to_native_key = 1
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Function to be used, when native keys are calles
" function WhichKeyNative(key)
" 	let g:which_key_fallback_to_native_key = 1
" 	execute "WhichKey" "a:key"
" 	let g:which_key_fallback_to_native_key = 0
" endfunction

" === Key Namings ===
" ! mappings
let g:which_key_map_cmds = {}
let g:which_key_map_cmds['m'] = "chmod"
let g:which_key_map_cmds['f'] = "figlet"
let g:which_key_map_cmds['s'] = "Source file"
let g:which_key_map_cmds['x'] = "Execute file"
let g:which_key_map_cmds['i'] = "Resource"

call which_key#register(',!', "g:which_key_map_cmds")


" r mappings
let g:which_key_map_r = {}
let g:which_key_map_r['c'] = {'name': 'C Code'}
let g:which_key_map_r['c']['t'] = "Main Template"
let g:which_key_map_r['c']['i'] = "Include"
let g:which_key_map_r['c']['d'] = "Define"
let g:which_key_map_r['j'] = {'name': 'Java Code'}
let g:which_key_map_r['j']['t'] = "Main Class"
let g:which_key_map_r['j']['i'] = "Import"
let g:which_key_map_r['j']['c'] = "Class"
let g:which_key_map_r['l'] = {'name': 'Latex Code'}
let g:which_key_map_r['l']['t'] = "Template"
let g:which_key_map_r['l']['b'] = "German Babel"

call which_key#register(',r', "g:which_key_map_r")


" m mappings
let g:which_key_map_m = {}
let g:which_key_map_m['m'] = "MAKE"
let g:which_key_map_m['c'] = "clean"
let g:which_key_map_m['a'] = "all"
let g:which_key_map_m['s'] = {'name': "+SUDO"}
let g:which_key_map_m['s']['i'] = "install"

call which_key#register(',m', "g:which_key_map_m")


" c mappings
let g:which_key_map_c = {}
let g:which_key_map_c['r'] = "Rename (Word)"
let g:which_key_map_c['f'] = "Format (Range)"
let g:which_key_map_c['q'] = "Quickfix (Line)"
let g:which_key_map_c['a'] = "Codeaction (Range)"
let g:which_key_map_c['A'] = "Codeaction (Buffer)"
let g:which_key_map_c['l'] = {'name': "+Lists"}
let g:which_key_map_c['l']['d'] = "Diagnostics"
let g:which_key_map_c['l']['e'] = "Extensions"
let g:which_key_map_c['l']['c'] = "Commands"
let g:which_key_map_c['l']['o'] = "Outline"
let g:which_key_map_c['l']['s'] = "Symbols"
let g:which_key_map_c['l']['l'] = "Resume Last"

call which_key#register(',c', "g:which_key_map_c")

" Mappings need to be buffer local, in order for nowait to take effect
augroup WhichKeyGroup
	autocmd!
	autocmd BufCreate,VimEnter * nnoremap <buffer><nowait><silent> <leader>! <Cmd>WhichKey ",!"<CR>
	autocmd BufCreate,VimEnter * nnoremap <buffer><nowait><silent> <leader>r <Cmd>WhichKey ",r"<CR>
	autocmd BufCreate,VimEnter * nnoremap <buffer><nowait><silent> <leader>m <Cmd>WhichKey ",m"<CR>
	autocmd BufCreate,VimEnter * nnoremap <buffer><nowait><silent> <leader>c <Cmd>WhichKey ",c"<CR>
augroup END


" === Native Keys ===
" g Mappigns
" let g:which_key_map_g = {}
" let g:which_key_map_g['D'] = [ "D", "GOTO Definition File" ]
" let g:which_key_map_g['d'] = [ "d", "GOTO Definition Function" ]
" let g:which_key_map_g['J'] = [ "'normal gJ'", "Join Lines" ]
" let g:which_key_map_g['P'] = [ "P", "Paste Before, Leave Cursor" ]
" let g:which_key_map_g['p'] = [ "p", "Paste After, Move Cursor" ]
" let g:which_key_map_g['T'] = [ "T", "TAB Prev" ]
" let g:which_key_map_g['t'] = [ "t", "TAB Next" ]
" let g:which_key_map_g['U'] = [ "U", "Make Uppercase" ]
" let g:which_key_map_g['u'] = [ "u", "Make Lowercase" ]
" let g:which_key_map_g['~'] = [ "~", "Swap Case" ]
" let g:which_key_map_g['f'] = [ "f", "GOTO File" ]
" let g:which_key_map_g['v'] = [ "v", "Reselect Visual" ]
" let g:which_key_map_g['t'] = [ "t", "GOTO Tag" ]

" call which_key#register('g', "g:which_key_map_g")
" nnoremap <silent> g <cmd>call WhichKeyNative('g')<CR>

