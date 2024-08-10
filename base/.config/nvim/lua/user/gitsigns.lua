local gs = require("gitsigns")

local jid = vim.fn.jobstart({ "git", "rev-parse", "--git-dir" })
local ret = vim.fn.jobwait({jid})[1]
if ret > 0 then
    vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles.git")
    vim.env.GIT_WORK_TREE = vim.fn.expand("~")
end

-- Always show signcolumn
vim.opt.signcolumn = "yes:1"

gs.setup({
    signs = {
        add = { hl = "GitSignsAdd", text = "┃" },
        change = { hl = "GitSignsChange", text = "┃" },
        delete = { hl = "GitSignsDelete", text = "" },
        topdelete = { hl = "GitSignsDelete", text = "" },
        changedelete = { hl = "GitSignsChange", text = "┃" },
    },
    preview_config = {
        border = 'rounded',
    },
    -- keymaps = {
    --     noremap = true,
    --
    --     ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'"},
    --     ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'"},
    --     ['n <leader>gn'] = '<cmd>Gitsigns next_hunk<CR>',
    --     ['n <leader>gN'] = '<cmd>Gitsigns prev_hunk<CR>',
    --
    --     ['n <leader>ga'] = '<cmd>Gitsigns stage_hunk<CR>',
    --     ['v <leader>ga'] = ':Gitsigns stage_hunk<CR>',
    --     ['n <leader>gA'] = '<cmd>Gitsigns stage_buffer<CR>',
    --     ['n <leader>gu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
    --     ['n <leader>gU'] = '<cmd>Gitsigns reset_buffer_index<CR>',
    --     ['n <leader>gr'] = '<cmd>Gitsigns reset_hunk<CR>',
    --     ['v <leader>gr'] = ':Gitsigns reset_hunk<CR>',
    --     ['n <leader>gR'] = '<cmd>Gitsigns reset_buffer<CR>',
    --
    --     ['n <leader>gp'] = '<cmd>Gitsigns preview_hunk<CR>',
    --     ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    --
    --     -- Text objects
    --     ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
    --     ['o ah'] = ':<C-U>Gitsigns select_hunk<CR>',
    --     ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>',
    --     ['x ah'] = ':<C-U>Gitsigns select_hunk<CR>',
    -- },
})

