require("user.options")
require("user.mappings")
require("user.autocommands")

vim.cmd("colorscheme my_new_vim_theme")

-- Plugins
local paq = require("paq")
paq {
    "savq/paq-nvim",
    "nvim-lua/plenary.nvim",
    "vijaymarupudi/nvim-fzf",
    'kyazdani42/nvim-web-devicons',

    "nvim-lualine/lualine.nvim",
    -- 'kyazdani42/nvim-tree.lua',
    'lewis6991/gitsigns.nvim',
    'ibhagwan/fzf-lua',
    'folke/which-key.nvim',
    'akinsho/toggleterm.nvim',

    "ur4ltz/surround.nvim",
    "windwp/nvim-autopairs",
    "numToStr/Comment.nvim",

    -- Completion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-calc',
    'quangnguyen30192/cmp-nvim-tags',

    -- Other
    'aserowy/tmux.nvim',
}
function paq_post_install()
    require("user.gitsigns")
    require("user.toggleterm")
    require("user.lualine")
    -- require("user.filetree")
    require("user.fzf")
    require("user.whichkey")
    require("user.surround")
    require("user.autopairs")
    require("user.comments")
    require("user.completion")
    require("user.tmux")
end
vim.cmd([[
augroup paq
    autocmd!
    autocmd User PaqDoneInstall lua paq_post_install()
augroup END]])
paq.install()

