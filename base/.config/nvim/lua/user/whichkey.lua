local wk = require("which-key")

vim.o.timeoutlen = 500

wk.setup({
    -- Doesn't work?
    -- operators = {
    --     ['#'] = "Comments",
    --     ['g@'] = "Comments",
    -- },
    key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
    },
    window = {
        padding = { 1, 0, 1, 0 },
        winblend = 10,
    }
})

wk.register({
  f = {
    name = "Files",
    f = "Find Files",
    e = "Explorer",
    r = "Recent Files",
    i = "init.lua",
    c = {
        name = "cd",
        c = "Find Directory",
        h = "cd here",
        ['.'] = "cd .."
    },
  },
  b = "Buffers",
  t = {
      name = "Terminal",
      t = "Toggle",
      T = "Toggle All",
      s = "Split",
      v = "VSplit",
      f = "Float",
  },
  g = {
      name = "Git",
      n = "Next Change",
      N = "Prev Change",
      a = "Add",
      A = "Add all",
      u = "Unstage",
      U = "Unstage all",
      r = "Reset",
      R = "Reset all",
      p = "Preview",
      b = "Blame",
  },
}, { prefix = "<leader>" })

-- wk.register({
--     ["#"] = "Comment Line",
--     O = "Comment Above",
--     o = "Comment below",
--     A = "Comment at end of line"
-- }, { prefix = "#" })

