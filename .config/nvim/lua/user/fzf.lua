local fzf = require("fzf")
local fzf_lua = require("fzf-lua")

fzf_lua.setup({
    hl = {
        normal = 'NormalFloat',
        border = 'NormalFloat',
        title = 'NormalFloat',
    },
    fzf_opts = {
        ['--ansi']        = '',
        ['--prompt']      = false,
        ['--info']        = 'inline',
        ['--height']      = '100%',
        ['--layout']      = false,
    },
    files = {
        cmd = [[bfs -type f -not -path '*/\.git/*' -printf '%P\n' 2>/dev/null]]
    },
})

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
map('n', '<Leader>F', ':FzfLua ', { noremap = true })
map('n', '<Leader>ff', '<Cmd>FzfLua files<CR>', opt)
map('n', '<Leader>fr', '<Cmd>FzfLua oldfiles<CR>', opt)
map('n', '<Leader>b', '<Cmd>FzfLua buffers<CR>', opt)
map('n', '<C-s>', '<Cmd>FzfLua blines<CR>', opt)
map('n', '<M-s>', '<Cmd>FzfLua lines<CR>', opt)
map('n', '<C-h>', '<Cmd>FzfLua help_tags<CR>', opt)

-- Cd function
function fab_fzf_cd ()
    coroutine.wrap(function ()
        local result = fzf.fzf([[bfs . -type d -not -path '*/\.git' -not -path '*/\.git/*' -printf '%P\n' 2>/dev/null]])
        if result then
            vim.cmd("cd " .. result[1])
        end
    end)()
end
map('n', '<Leader>fcc', '<Cmd>lua fab_fzf_cd()<CR>', opt)

