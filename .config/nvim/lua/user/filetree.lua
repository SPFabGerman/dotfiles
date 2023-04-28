local nt = require("nvim-tree")
local tree_cb = require('nvim-tree.config').nvim_tree_callback

local keylist = {
    { key = {"<CR>", "<Right>", "<2-LeftMouse>"}, cb = tree_cb("edit") },
    { key = "<Tab>",                        cb = tree_cb("preview") },
    { key = "v",                            cb = tree_cb("vsplit") },
    { key = "s",                            cb = tree_cb("split") },
    { key = { "<BS>", "<Left>" },           cb = tree_cb("close_node") },
    { key = "I",                            cb = tree_cb("toggle_ignored") },
    { key = "H",                            cb = tree_cb("toggle_dotfiles") },
    { key = "<F5>",                         cb = tree_cb("refresh") },
    { key = "i",                            cb = tree_cb("create") },
    { key = "R",                            cb = tree_cb("remove") },
    { key = "r",                            cb = tree_cb("trash") },
    { key = "m",                            cb = tree_cb("rename") },
    { key = "M",                            cb = tree_cb("full_rename") },
    { key = "y",                            cb = tree_cb("copy") },
    { key = "d",                            cb = tree_cb("cut") },
    { key = "p",                            cb = tree_cb("paste") },
    -- { key = "<c-y>",                     cb = tree_cb("copy_name") },
    { key = "<c-y>",                        cb = tree_cb("copy_path") },
    { key = "[c",                           cb = tree_cb("prev_git_item") },
    { key = "]c",                           cb = tree_cb("next_git_item") },
    { key = "q",                            cb = tree_cb("close") },
    { key = "h",                            cb = tree_cb("toggle_help") },
}

local iconlist = {
    default = '',
    symlink = '',
    git = {
        unstaged = "",
        renamed = "➜",
        deleted = "",
        staged = "✓",
        unmerged = "",
        untracked = "◌",
        ignored = "◌",
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = "",
    },
}

nt.setup({
    -- auto_close = true,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        ignore_list = { "help" }
    },
    git = {
        enable = true,
        ignore = false,
    },
    view = {
        signcolumn = "no",
        mappings = {
            custom_only = true,
            list = keylist,
        },
    },
    renderer = {
        indent_markers = {
            enable = true,
        },
        special_files = {
            ["README.md"]=1, ["README"]=1, ["README.txt"]=1,
            ["Makefile"]=1, ["MAKEFILE"]=1,
        },
        icons = {
            glyphs = iconlist,
        },
    },
})

vim.api.nvim_set_keymap("n", "<leader>fe", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.cmd([[
    highlight NvimTreeFolderIcon NONE
    highlight link NvimTreeFolderIcon Directory
]])
-- Auto Close:
vim.cmd([[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]])

