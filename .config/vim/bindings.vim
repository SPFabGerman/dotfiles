" __     ___             ____  _           _ _                 
" \ \   / (_)_ __ ___   | __ )(_)_ __   __| (_)_ __   __ _ ___ 
"  \ \ / /| | '_ ` _ \  |  _ \| | '_ \ / _` | | '_ \ / _` / __|
"   \ V / | | | | | | | | |_) | | | | | (_| | | | | | (_| \__ \
"    \_/  |_|_| |_| |_| |____/|_|_| |_|\__,_|_|_| |_|\__, |___/
"                                                    |___/     
" A Config File that contains only Vim compatible, but not Vim specific settings.
" It can be sourced from vim and neovim.
" It is intended to work in every instance. (Even SSH)

" === KEYBOARD SHORTCUTS ===

let mapleader = ","
set timeoutlen=2500

" Ctrl-Backspace to remove word
inoremap <C-H> <C-O>daw

" Easy Newline in Command Mode
nnoremap <CR> o<Esc>
" TODO: Remap Alt-Cr to Shift or Ctrl-Cr in St
nnoremap <M-CR> O<ESC>

" Navigation between Panes with Alt Key
nnoremap <M-Up> <C-W><Up>
nnoremap <M-Down> <C-W><Down>
nnoremap <M-Right> <C-W><Right>
nnoremap <M-Left> <C-W><Left>
" Move Panes with Ctrl-W -> Shift-Arrow
nnoremap <C-W><S-Up> <C-W>K
nnoremap <M-S-Up> <C-W>K
nnoremap <C-W><S-Down> <C-W>J
nnoremap <M-S-Down> <C-W>J
nnoremap <C-W><S-Left> <C-W>H
nnoremap <M-S-Left> <C-W>H
nnoremap <C-W><S-Right> <C-W>L
nnoremap <M-S-Right> <C-W>L
" Move between Tabs with Ctrl+Alt
nnoremap <C-M-Right> gt
nnoremap <C-M-Left> gT

" Quit with double Esc
" nnoremap <Esc><Esc> :q<CR>

" Redo with Captial U
nnoremap U <C-R>
" More logical yank
nnoremap Y y$

" Ctrl+F to search and Ctrl+G (right next) Unhighlight Results
" nnoremap <C-F> /
inoremap <C-F> <ESC>/
nnoremap <C-G> :nohlsearch<CR>
" Center Highlighting afer search with n/N
nnoremap n nzz
nnoremap N Nzz
" * marks only the current word for search
nnoremap * *N

" Goto Tag
nnoremap gt g<C-]>
nnoremap <C-W>t <C-W>g<C-]>
nnoremap <C-P>t <C-W>g]1<CR><C-W>T
" Goto File
nnoremap <C-P>f <C-W>gf

" Window Stuff
" Open with prompt
nnoremap <C-W>S :split 
nnoremap <C-W>V :vsplit 
" Open on longer axis
let fontratio = 2.5
nnoremap <expr> <C-W>o ( winheight(0) * fontratio > winwidth(0) ? ":split" : ":vsplit" ) . "<CR>"
nnoremap <expr> <C-W><C-W> ( winheight(0) * fontratio > winwidth(0) ? ":split" : ":vsplit" ) . "<CR>"
nnoremap <expr> <C-W>O ( winheight(0) * fontratio > winwidth(0) ? ":split" : ":vsplit" ) . " "

" Buffer Stuff
function FZFBufferSelect()
	let bufnr = bufnr('$')
	let bufferlist = []
	let i = 1
	while i <= bufnr
		if buflisted(i)
			let bufferlist += [i]
		endif
		let i += 1
	endwhile
	let buffernames = []
	let i = 0
	while i < len(bufferlist)
		if bufname(bufferlist[i]) != ''
			let n = bufname(bufferlist[i])
		else
			let n = '[No Name]'
		endif
		let buffernames += [string(i+1) . ': ' . n]
		let i += 1
	endwhile
	" TODO: Don't open when only one match and instant switch, when
	" exactly two
	" TODO: Use Closure
	function! s:Fzfopt_Callback(ids, status, lines) dict
		if a:status != 0
			return
		endif
		let ret = a:lines[0]
		let rnum = split(ret, ":")[0] - 1
		let bnum = a:ids[rnum]
		execute 'buffer' string(bnum)
	endfunction
	let fzfopt = { 'lines': buffernames, 'Callback': function("s:Fzfopt_Callback", [bufferlist]) }
	call OpenFZF(fzfopt)
endfunction
nnoremap <C-B> <Nop>
nnoremap <C-B><C-B> :call FZFBufferSelect()<CR>

" Tab (Page) Movements
nnoremap <C-P>n :tabnew<CR>
nnoremap <C-P>s :split<CR><C-W>T
" Move
nnoremap <C-P>m <C-W>T
nnoremap <C-P>q :tabclose<CR>
nnoremap <C-P>c :tabclose<CR>
" Focus Tab
noremap <C-P>l gt
noremap <C-P>p gt
noremap <C-P><C-P> gt
noremap <C-P>h gT

" Display all Sections and mark them for search
function! ShowAllSections()
   g/=== .* ===/number
   normal ``
   let @/ = "=== .* ==="
endfunction
nnoremap <Leader>s :call ShowAllSections()<CR>

" Move Lines in Visual Mode
vnoremap <C-Up> :m-2<CR>gv=gv
vnoremap <C-Down> :m'>+1<CR>gv=gv

" Shell Commands
nnoremap <leader>!m :!chmod  %<Left><Left>
nnoremap <leader>!f O:.!figlet 
nnoremap <leader>!s :source %<CR>
nnoremap <leader>!x :!./%<CR>
nnoremap <leader>!i :source ~/.config/nvim/init.vim<CR>

" Template Insertion Commands
" TODO: Enable only for correct buffer
" C Code
nnoremap <leader>rct :read ~/.config/vim/code_templates/c_template.txt<CR>ggdd3j$
nnoremap <leader>rci G?^#include<CR>o#include <lt>><Left>
nnoremap <leader>rcd G?^#define<CR>o#define 
" Java Code
nnoremap <leader>rjt :read ~/.config/vim/code_templates/java_template.txt<CR>ggdd:execute "%s/<++>/" . expand("%:t:r") . "/g"<CR>gg3j$
nnoremap <leader>rjc :read ~/.config/vim/code_templates/java_class.txt<CR>ggdd:execute "%s/<++>/" . expand("%:t:r") . "/g"<CR>gg2j^f(
nnoremap <leader>rji G?^import<CR>oimport 

" Latex Code
nnoremap <leader>rlt :read ~/.config/vim/code_templates/latex_template.txt<CR>ggdd:execute "%s/<++>/" . expand("%:t:r") . "/g"<CR>gg8j$:w<CR>:e<CR>
nnoremap <leader>rlb G?^\\usepackage<CR>o\usepackage[ngerman]{babel}<Esc>

" === Commands ===
" Save and edit
" (Usefull if you want to 'Save As' or update Syntax Highlighting.)
command! -nargs=? -complete=file WE w <args> | e <args>

" Auto open buffer or edit new file
function AutoBOE(file)
	if bufexists(a:file)
		execute "buffer" a:file
	else
		execute "edit" a:file
	endif
endfunction
command! -nargs=1 -complete=file BoE call AutoBOE("\<args>")
command! -nargs=1 -complete=file EoB call AutoBOE("\<args>")

" === Configs ===

" Load my custom Color Scheme
colorscheme my_vim_theme

" Enable Numbers + Relativenumbers
set number relativenumber

function OnWinEnter()
	if &filetype =~# '\v(help|nerdtree)' || expand('%') =~# '^term://'
		return
	endif
	set cursorline relativenumber
endfunction

" Setup for current window
augroup CursorLine
  au!
  au WinEnter,BufEnter * call OnWinEnter()
  au WinLeave,BufLeave * set nocursorline norelativenumber
augroup END

" Enable Lazy Redraw to speed up scrolling
" set lazyredraw

" Tabsize and Auto Indent
" set tabstop=4
let &shiftwidth=&tabstop
" set expandtab

" set scrolloff=1

" show cmd keys in status line
set showcmd

" Make Split to Right and Below
set splitbelow splitright

" Ignore Case when searching
set ignorecase "smartcase

" Comletion checks included files
set complete=t,.,i,w,b,u
set completeopt=menuone,preview,noinsert
" Completion for Tags
inoremap <C-X><C-T> <C-X><C-]>

" :s Preview
set inccommand=nosplit

" === Source other files

source ~/.config/vim/bettermath.vim

" === Load Plugins and Configs ===

source ~/.config/vim/NerdTree_Setup.vim
source ~/.config/vim/Lightline_Setup.vim
source ~/.config/vim/Devicons_Setup.vim
source ~/.config/vim/EasyMotionSetup.vim
" source ~/.config/vim/ContextSetup.vim

" Commentary Setup
augroup Commentary
	autocmd!
	" Switch to line comments for C
	autocmd FileType c,h setlocal commentstring=//\ %s
augroup END
nmap # gcc
vmap # gc

" Surround Setup
" Change Visual Mode Capital S to s. (We have c in case we need s.)
vmap s S

" Auto Pairs Setup
let g:AutoPairsShortcutJump = '<M-n>'
" Quickly insert (wrap) stuff into brackets
let g:AutoPairsShortcutFastWrap = '<M-w>'

" Load all the Plugins
call plug#begin()
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

Plug 'NLKNguyen/c-syntax.vim'

Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'

Plug 'takac/vim-hardtime'
Plug 'liuchengxu/vim-which-key'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}
Plug 'josa42/coc-sh', {'do': 'yarn install --frozen-lockfile'}

Plug 'vim-python/python-syntax'
Plug 'kevinoid/vim-jsonc'

" Plug 'wellle/context.vim'
call plug#end()

" Configs to be sourced, after plugins are loaded
augroup AutoPairs
	autocmd!
	" Disable Pairs for quotes in vim, since it messes with comments
	autocmd Filetype vim let b:AutoPairs = copy(g:AutoPairs) | unlet b:AutoPairs['"']
augroup END

