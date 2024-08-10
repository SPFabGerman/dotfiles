local c = require("Comment")

c.setup({
    toggler = {
        line = '##',
        block = '<M-#><M-#>',
    },
    opleader = {
        line = '#',
        block = '<M-#>',
    },
    extra = {
        above = '#O',
        below = '#o',
        eol = '#A',
    },
})

