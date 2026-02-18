-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- [[ Configure Telescope ]]

require('telescope').setup({
  -- See `:help telescope` and `:help telescope.setup()`
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  --
  -- defaults = { mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine' } } }
  -- pickers = {}
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown()
    },
  },
})

-- Make builtin neovim actions use telescope
require('telescope').load_extension('ui-select')

-- Use fzf syntax for matching
require('telescope').load_extension('fzf')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<C-h>', builtin.help_tags, { desc = 'Help' })

vim.keymap.set('n', '<leader><leader>', builtin.commands, { desc = 'Commands' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>r', builtin.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search' })

-- vim.keymap.set('n', '<leader>/', function()
--   -- Override default behavior and theme when searching
--   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
--   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     winblend = 10,
--     previewer = false,
--   })
-- end, { desc = 'Search' })

-- Use Telescope for choosing LSP target instead of Quickfix list
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf

    vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = 'Goto References' })
    vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gO', builtin.lsp_workspace_symbols, { buffer = buf, desc = 'Workspace symbols' })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
