local fzf = require("fzf-lua")

-- We link highlights this way, because the normal fzf.setup method does not seem to follow links and therefor does not set all highlight groups.
vim.api.nvim_set_hl(0, "FzfLuaNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })

local map = vim.keymap.set
map('n', '<Leader>ff', fzf.files, { desc = "Find files" })
map('n', '<Leader>fr', fzf.oldfiles, { desc = "Recent files" })
map('n', '<Leader>b', fzf.buffers, { desc = "Buffers" })
map('n', '<C-s>', fzf.lines, { desc = "Search buffer Lines" })
map('n', '<C-h>', fzf.help_tags, { desc = "Search help" })

