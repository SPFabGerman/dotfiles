" Setup for Devicons

let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}

function! DefineIcon(ext, sym)
    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols[a:ext] = a:sym
endfunction

call DefineIcon('sh','')
call DefineIcon('zsh','')
call DefineIcon('md','')
call DefineIcon('vim','')

