vim.cmd([[
    augroup closewithq
        autocmd!
        autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    augroup end
]])

