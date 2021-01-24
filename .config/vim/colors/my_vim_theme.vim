" My own vim color theme

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

" Initialize Color Helper Functions
source ~/.config/nvim/colorGen.vim
set termguicolors

set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="my_vim_theme"

execute "hi Normal ctermfg=15 ctermbg=None cterm=None guibg=None gui=None guifg=" . foreground

" Selections
" hi IncSearch	cterm=NONE ctermbg=grey ctermfg=None
call GUIHighlight("IncSearch", -1, -1, "reverse")
call GUIHighlight("Search", -1, darkgrey, "None")
call GUIHighlight("Substitute", lightred, darkgrey, "Bold")

" hi Visual	ctermbg=darkgrey
call GUIHighlight("Visual", -1, -1, "reverse")

" Command Outputs
call GUIHighlight("MoreMsg", white, -1, "None")
call GUIHighlight("ModeMsg", white, -1, "None")
call GUIHighlight("Question", white, -1, "None")

" GUI Stuff
call GUIHighlight("WildMenu", black, lightgrey, "None")
call GUIHighlight("Pmenu", white, darkgrey, "None")
call GUIHighlight("PmenuSel", white, black, "None")
call GUIHighlight("NormalFloat", -1, black, "None")
highlight NormalFloatDense guibg=None blend=0 guifg=white ctermbg=None ctermfg=white
set winblend=10
set pumblend=10

" Multiple Windows
" Use different fg colors to avoid '^' Stuff
call GUIHighlight("StatusLine", "white", "black", "None")
call GUIHighlight("StatusLineNC", "gray", "black", "None")
call GUIHighlight("VertSplit", "lightgrey", "lightgrey", "Bold")

" Backgrounds
set cursorline
hi CursorLine ctermbg=239 cterm=None guibg=#404040
execute "hi CursorLineNr ctermbg=239 ctermfg=white gui=None guibg=#404040 guifg=".guicolors[white]
call GUIHighlight("LineNr", darkgrey, -1, "None")
call HighlightLink("SignColumn", "LineNr")
call GUIHighlight("EndOfBuffer", darkgrey, -1, "None")

" Special Things in a file (Folds and Diffs)
call GUIHighlight("Folded", darkgrey, -1, "None")
call GUIHighlight("FoldColumn", darkgrey, -1, "None")

call GUIHighlight("DiffAdd", white, darkgreen, "bold")
call GUIHighlight("DiffChange", white, darkblue, "bold")
call GUIHighlight("DiffDelete", white, darkred, "bold")
call GUIHighlight("DiffText", white, -1, "None")

call GUIHighlight("Underlined", -1, -1, "underline")
call GUIHighlight("Directory", darkyellow, -1, "underline")

" === Syntax Highlighting ===
call GUIHighlight("Comment", darkgrey, -1, "None")
call GUIHighlight("Ignore", darkgrey, -1, "None")

call GUIHighlight("Constant", lightgreen, -1, "None")
call GUIHighlight("String", darkgreen, -1, "None")
call GUIHighlight("Identifier", lightblue, -1, "None")
call GUIHighlight("Function", darkblue, -1, "None")
call GUIHighlight("Statement", lightmagenta, -1, "None")
call GUIHighlight("PreProc", darkmagenta, -1, "None")
call GUIHighlight("Type", lightcyan, -1, "None")
call GUIHighlight("Typedef", darkcyan, -1, "None")

call GUIHighlight("Operator", darkyellow, -1, "None")
" hi Delimiter	ctermfg=white
call HighlightLink("Delimiter", "Operator")
call GUIHighlight("MatchParen", -1, -1, "underline,bold")

call GUIHighlight("Title", darkgreen, -1, "bold,underline")

call GUIHighlight("Special", lightyellow, -1, "None")
call HighlightLink("SpecialKey", "Special")
call HighlightLink("NonText", "Special")

" Compiler Stuff
call GUIHighlight("Error", white, darkred, "None")
call GUIHighlight("ErrorMsg", white, darkred, "None")
call GUIHighlight("WarningMsg", black, darkyellow, "None")


" === Different Tag Highlights ===
call GUIHighlight("Tag", -1, -1, "underline")
call GUIHighlight("Tag_f", darkblue, -1, "underline") "Functions
call GUIHighlight("Tag_v", lightblue, -1, "underline") "Variables
call GUIHighlight("Tag_t", lightcyan, -1, "underline") "Types
call HighlightLink("Tag_u", "Tag_t") "Union
call HighlightLink("Tag_s", "Tag_t") "Struct
call HighlightLink("Tag_g", "Tag_t") "Enum
call HighlightLink("Tag_m", "Tag_v") "Member
call HighlightLink("Tag_e", "Tag_v") "Enumerator
call GUIHighlight("Tag_d", darkmagenta, -1, "underline") "Macro
call HighlightLink("Tag_h", "Tag_d") "Header

