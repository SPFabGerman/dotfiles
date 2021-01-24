" Shortcut. When do you use semicolon anyway? And <Leader><Leader> is just one
" key to much.
map ; <Plug>(easymotion-prefix)

" Easy Repeat last movement.
map <Plug>(easymotion-prefix); <Plug>(easymotion-repeat)
map <Plug>(easymotion-prefix). <Plug>(easymotion-repeat)

" Support for next and prev.
map <Plug>(easymotion-prefix)n <Plug>(easymotion-next)
map <Plug>(easymotion-prefix)N <Plug>(easymotion-prev)

" Implement Biderectional Search
map <Plug>(easymotion-prefix)f <Plug>(easymotion-s)
map <Plug>(easymotion-prefix)F <Plug>(easymotion-s)
map <Plug>(easymotion-prefix)t <Plug>(easymotion-bd-t)
map <Plug>(easymotion-prefix)T <Plug>(easymotion-bd-t)
" Multi Character Search
map <Plug>(easymotion-prefix)s <Plug>(easymotion-s2)
map <Plug>(easymotion-prefix)S <Plug>(easymotion-s2)
map <Plug>(easymotion-prefix)/ <Plug>(easymotion-sn)

" Bidirectional word movements
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)
map <Plug>(easymotion-prefix)b <Plug>(easymotion-bd-w)
map <Plug>(easymotion-prefix)W <Plug>(easymotion-bd-W)
map <Plug>(easymotion-prefix)B <Plug>(easymotion-bd-W)
map <Plug>(easymotion-prefix)e <Plug>(easymotion-bd-e)
map <Plug>(easymotion-prefix)E <Plug>(easymotion-bd-E)

" Biderectional Line Movements
map <Plug>(easymotion-prefix)j <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)J <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)k <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)K <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)<Up> <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)<Down> <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)<S-Up> <Plug>(easymotion-sol-bd-jk)
map <Plug>(easymotion-prefix)<S-Down> <Plug>(easymotion-sol-bd-jk)

