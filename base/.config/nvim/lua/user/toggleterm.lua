local term = require("toggleterm")

vim.o.hidden = true

term.setup({
    open_mapping = "<C-t>",
    insert_mappings = true,
    direction = 'horizontal',
    size = function(term)
        if term.direction == "horizontal" then
            return math.min(vim.o.lines * 0.4, 10)
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
})

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
map("n", "<Leader>tt", "<Cmd>ToggleTerm<Cr>", opt)
map("n", "<Leader>tT", "<Cmd>ToggleTermToggleAll<Cr>", opt)
map("n", "<Leader>ts", "<Cmd>ToggleTerm direction=horizontal<Cr>", opt)
map("n", "<Leader>tv", "<Cmd>ToggleTerm direction=vertical<Cr>", opt)
map("n", "<Leader>tf", "<Cmd>ToggleTerm direction=float<Cr>", opt)

map("t", "<C-n>", "<C-\\><C-n>", opt)
map("t", "<M-Up>", "<C-\\><C-n><C-w><Up>", opt)
map("t", "<M-Down>", "<C-\\><C-n><C-w><Down>", opt)
map("t", "<M-Left>", "<C-\\><C-n><C-w><Left>", opt)
map("t", "<M-Right>", "<C-\\><C-n><C-w><Right>", opt)

-- map("t", "%%", "bufname('#')", { noremap = true, silent = true, expr = true })

