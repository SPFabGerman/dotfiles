local map = vim.api.nvim_set_keymap
local opt = { noremap = true }
local nos = { noremap = true, silent = true }

-- Space is Leader
map("", "<Space>", "<Nop>", opt)
vim.g.mapleader = " "
map("n", "<Leader>fi", "<Cmd>edit ~/.config/nvim/init.lua<CR>", nos)
-- cd to file
map("n", "<Leader>fch", "'<Cmd>cd ' . expand('%:h') . '<CR>'", { noremap = true, silent = true, expr = true })
map("n", "<Leader>fc.", "<Cmd>cd ..<CR>", nos)

-- Navigation between Panes with Alt Key
map("n", "<M-Up>", "<C-W><Up>", opt)
map("n", "<M-Down>", "<C-W><Down>", opt)
map("n", "<M-Right>", "<C-W><Right>", opt)
map("n", "<M-Left>", "<C-W><Left>", opt)
-- Move Panes with Ctrl-W -> Shift-Arrow
map("n", "<C-W><S-Up>", "<C-W>K", opt)
map("n", "<M-S-Up>", "<C-W>K", opt)
map("n", "<C-W><S-Down>", "<C-W>J", opt)
map("n", "<M-S-Down>", "<C-W>J", opt)
map("n", "<C-W><S-Left>", "<C-W>H", opt)
map("n", "<M-S-Left>", "<C-W>H", opt)
map("n", "<C-W><S-Right>", "<C-W>L", opt)
map("n", "<M-S-Right>", "<C-W>L", opt)

-- Splitting with prompt
map("n", "<C-W>S", ":split ", opt)
map("n", "<C-W>V", ":vsplit ", opt)

-- Better Redo and Yank
map("n", "U", "<C-R>", opt)
map("n", "Y", "y$", opt)
-- Don't save to clipboard, when using x
map("n", "x", '"_x', opt)

-- Better Jumps for Searching
map("n", "n", "nzz", opt)
map("n", "N", "Nzz", opt)
map("n", "*", "*N", opt)

-- Move Lines in Visual Mode
map("v", "<C-Up>", ":m-2<CR>gv=gv", nos)
map("v", "<C-Down>", ":m'>+1<CR>gv=gv", nos)
map("v", "=", "=gv", opt)
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

-- Don't replace clipboard when pasting
map("v", "p", '"_dP', opt)
-- Don't save to clipboard, when using x
map("v", "x", '"_x', opt)

