-- Mouse and Keyboard Setup
vim.opt.showcmd = true
vim.opt.mouse = "a"
vim.opt.timeoutlen = 2500

-- Better Splitting
vim.opt.splitbelow, vim.opt.splitright = true, true

vim.opt.wrap = false
vim.opt.scrolloff, vim.opt.sidescrolloff = 5, 5

-- Pop-Up menu height
vim.opt.pumheight = 10

-- Highlight Cursorline and show numbers
vim.opt.cursorline = true
vim.opt.number, vim.opt.relativenumber = true, true

-- Backup Recovery: faster swapfiles
vim.opt.updatetime = 1000

-- Tabs and Spaces and Indents!
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Better Search and Replace
vim.opt.ignorecase, vim.opt.smartcase = true, true
vim.opt.inccommand = "nosplit"

vim.opt.clipboard = { "unnamed", "unnamedplus" }

-- Completion Options
vim.opt.completeopt = { "menuone", "preview", "noinsert" }

-- Terminal Title
if vim.env.TMUX == nil then
    vim.opt.titlestring = "NVim: %f"
else
    vim.opt.titlestring = "%f"
end
vim.opt.title = true

