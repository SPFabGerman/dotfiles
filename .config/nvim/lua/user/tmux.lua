if vim.env.TMUX == nil then
    return
end

local tmux = require("tmux")

tmux.setup({
    navigation = {
        persist_zoom = true,
        cycle_navigation = false,
    },
    copy_sync = {
        enable = false,
        sync_clipboard = false,
    },
})

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
map("n", "<M-Left>",  [[<cmd>lua require("tmux").move_left()<cr>]],   opt)
map("n", "<M-Down>",  [[<cmd>lua require("tmux").move_bottom()<cr>]], opt)
map("n", "<M-Up>",    [[<cmd>lua require("tmux").move_top()<cr>]],    opt)
map("n", "<M-Right>", [[<cmd>lua require("tmux").move_right()<cr>]],  opt)

