require("user.options")
require("user.mappings")
require("user.autocommands")

vim.cmd("colorscheme my_new_vim_theme")

-- Load Plugins
require("user.gitsigns")
require("user.toggleterm")
require("user.lualine")
-- require("user.filetree")
require("user.fzf")
require("user.whichkey")
-- require("user.surround")
require("user.autopairs")
require("user.comments")
-- require("user.completion")
require("user.tmux")
