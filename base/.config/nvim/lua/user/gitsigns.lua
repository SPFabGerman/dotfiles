local gs = require("gitsigns")

gs.setup({
    signs = {
        changedelete = { text = "┃" },
    },
    signs_staged = {
        changedelete = { text = "┃" },
    },
    attach_to_untracked = true,


    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']g', function()
            gs.nav_hunk('next')
        end, { desc = "Next Git Hunk" })

        map('n', '[g', function()
            gs.nav_hunk('prev')
        end, { desc = "Prev Git Hunk" })

        -- Actions
        map('n', '<leader>ga', gs.stage_hunk, { desc = "Add" })
        map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset" })

        map('v', '<leader>ga', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Add" })

        map('v', '<leader>gr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = "Reset" })

        map('n', '<leader>gA', gs.stage_buffer, { desc = "Add all" })
        map('n', '<leader>gR', gs.reset_buffer, { desc = "Reset all" })
        map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview" })

        map('n', '<leader>gb', function()
            gs.blame_line({ full = true })
        end, { desc = "Blame" })

        map('n', '<leader>gd', gs.diffthis, { desc = "Diff" })

        map('n', '<leader>gD', function()
            gs.diffthis('~')
        end, { desc = "Diff all" })

        map('n', '<leader>gQ', function() gs.setqflist('all') end, { desc = "QuickFix all" })
        map('n', '<leader>gq', gs.setqflist, { desc = "QuickFix" })

        -- Text object
        map({'o', 'x'}, 'ih', gs.select_hunk, { desc = "Git Hunk" })
        map({'o', 'x'}, 'ah', gs.select_hunk, { desc = "Git Hunk" })
    end
})

