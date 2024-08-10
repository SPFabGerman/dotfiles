local function statusline_lineinfo()
    local cn = '' .. vim.fn.col(".")
    local ln = '' .. vim.fn.line(".") .. '/' .. vim.fn.line("$")
    return ln -- .. cn
end

require("lualine").setup({
    options = {
        theme = 'onedark'
    },
    sections = {
        lualine_a = {
            'mode',
            { "'' .. vim.fn.reg_recording()", cond = function() return vim.fn.reg_recording() ~= "" end }, -- Macro Recordings
        },
        lualine_b = {
            { "filename", path = 1 --[[ Relative Path ]], symbols = { modified = " ", readonly = " " } },
            { "filetype", icon_only = true, colored = false }
        },
        lualine_c = {
            "vim.fn.fnamemodify(vim.fn.getcwd(), ':t')" -- CWD
        },

        lualine_x = {},
        lualine_y = {
            { "fileformat", symbols = { unix = '', dos = '', mac = '' } },
            { "encoding", cond = function() return vim.bo.fileencoding ~= "utf-8" end },
        },
        lualine_z = {
            statusline_lineinfo
        },
    },

    inactive_sections = {
        lualine_a = { "'-------'" },
        lualine_b = {
            { "filename", path = 1 --[[ Relative Path ]], symbols = { modified = " ", readonly = " " } },
            { "filetype", icon_only = true, colored = false }
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
            { "fileformat", symbols = { unix = '', dos = '', mac = '' } },
            { "encoding", cond = function() return vim.bo.fileencoding ~= "utf-8" end },
        },
        lualine_z = {
            statusline_lineinfo
        },
    },
})

vim.o.showmode = false

