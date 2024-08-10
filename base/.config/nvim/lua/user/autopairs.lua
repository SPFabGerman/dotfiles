local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require('nvim-autopairs.conds')

npairs.setup({
    disable_in_macro = true,
    disable_in_visualblock = true,
})

-- === Custom Rules ===

-- Add spaces after pairs
npairs.add_rules {
    Rule(' ', ' ')
    :with_pair(function (opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end)
    :with_del(function (opts)
        local col = vim.fn.col('.')
        local pair = opts.line:sub(col - 2, col + 1)
        return vim.tbl_contains({ '(  )', '[  ]', '{  }' }, pair)
    end)
    :with_cr(function () return false end),
}

