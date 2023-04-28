local s = require("surround")

s.setup({
    mappings_style = "surround",
    pairs = {
        nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}},
        linear = {{"'", "'"}, {"`", "`"}, {'"', '"'}, {'*', '*'}}
    },
})

-- Add Surroundings with just s
vim.api.nvim_set_keymap("n", "s", "<cmd>set operatorfunc=SurroundAddOperatorMode<cr>g@", { noremap = true })

for _, pair in ipairs(table.merge(vim.g.surround_pairs.nestable, vim.g.surround_pairs.linear)) do
    -- Change Insert Mode Mapping from <C-s><char><C-s> to <C-s><char><cr>
    vim.api.nvim_del_keymap("i", "<c-s>" .. pair[1] .. "<c-s>")
    vim.api.nvim_set_keymap("i", "<c-s>" .. pair[1] .. "<cr>", pair[1] .. "<cr>" .. pair[2] .. "<esc>O", { noremap = true })
    -- When using <C-s><char><charpair> just insert pair normally
    vim.api.nvim_set_keymap("i", "<c-s>" .. pair[1] .. pair[2], pair[1] .. pair[2], { noremap = true })
end

