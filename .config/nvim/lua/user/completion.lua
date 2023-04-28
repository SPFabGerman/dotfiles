local cmp = require("cmp")

local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

cmp.setup {
    mapping = {
        ["<Up>"] = cmp.mapping({
            i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        }),
        ["<Down>"] = cmp.mapping({
            i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
        ["<C-y>"] = cmp.config.disable, -- remove the default <C-y> mapping
        ["<Esc>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
        ["<Esc>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false --[[ Only use explicitly selected items ]]}), { "i" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm { select = false }
            -- elseif check_backspace() then
            --     fallback()
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lua" },
        { name = 'tags' },
        { name = "buffer" },
        { name = "path" },
    },
    formatting = {
        fields = { "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Nvim]",
                calc = "[=]",
                tags = "[Tags]",
            })[entry.source.name]
            return vim_item
        end,
    },
    window = {
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
    },
    preselect = cmp.PreselectMode.Item,
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
}

cmp.setup.cmdline(':', {
    sources = {
        { name = 'cmdline' }
    },
})
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    },
})

