local wk = require("which-key")

wk.add({
    { "<leader>b", desc = "Buffers" },
    { "<leader>f", group = "Files" },
    { "<leader>fc", group = "cd" },
    { "<leader>fc.", desc = "cd .." },
    { "<leader>fcc", desc = "Find Directory" },
    { "<leader>fch", desc = "cd here" },
    { "<leader>fe", desc = "Explorer" },
    { "<leader>ff", desc = "Find Files" },
    { "<leader>fi", desc = "init.lua" },
    { "<leader>fr", desc = "Recent Files" },
    { "<leader>g", group = "Git" },
    { "<leader>t", group = "Terminal" },
    { "<leader>tT", desc = "Toggle All" },
    { "<leader>tf", desc = "Float" },
    { "<leader>ts", desc = "Split" },
    { "<leader>tt", desc = "Toggle" },
    { "<leader>tv", desc = "VSplit" },
})

