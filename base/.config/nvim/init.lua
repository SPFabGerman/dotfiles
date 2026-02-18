-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- {{{ Options
-- See `:help option-list`

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

vim.o.title = true
vim.o.titlestring = "%t%( %M%)"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Keep indentation on line break
vim.o.breakindent = true

-- Case-insensitive searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.winborder = "rounded"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 3

-- Disable visual wrapping of text
vim.o.wrap = false

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', precedes = '⇠', extends = '⇢' }

-- Better indentation and tab lengths
vim.o.tabstop = 4
-- vim.o.softtabstop = 4
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Fall back to C-like indenting if no `indentexpr` is defined.
vim.o.smartindent = true

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s).
vim.o.confirm = true
-- }}}

-- {{{ Basic Keymaps

vim.keymap.set('n', 'U', '<C-R>')
vim.keymap.set({'n', 'v'}, 'x', '"_x')

vim.keymap.set('v', 'p', 'P')
vim.keymap.set('v', 'P', 'p')

vim.keymap.set('v', '<C-Up>', ":m-2<CR>gv=gv")
vim.keymap.set('v', '<C-Down>', ":m'>+1<CR>gv=gv")
vim.keymap.set('v', '=', '=gv')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
-- See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('closewithq', { clear = true }),
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf })
  end,
})
-- }}}

-- {{{ LSP
-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md for default configurations.

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-extra-bindings', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = buf, desc = 'Goto Definition' })
  end,
})

-- Setting up Lua LSP for Neovim
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.resolve(vim.fn.stdpath('config'))
        -- and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim (see `:h lua-module-load`)
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

vim.lsp.enable('lua_ls')
-- }}}

-- {{{ Treesitter
-- NOTE: TreeSitter support is still considered experimental.

-- Note: Installing of TreeSitter Grammars is done by NixOS, because `:TSInstall` doesn't work correctly on NixOS.
-- We use this helper function to get a list of all installed grammars.
local function get_all_grammars()
  local f = vim.api.nvim_get_runtime_file('parser/*', true)
  local g = {}
  for k,v in pairs(f) do
    g[k] = v:match("^.*/(.*).so$")
  end
  return g
end

-- For more configuration options see https://github.com/nvim-treesitter/nvim-treesitter.

-- Enable highlighting by TreeSitter
vim.api.nvim_create_autocmd('FileType', {
  -- See https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md for a list of supported languages.
  -- pattern = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'go', 'rust', 'python' },
  pattern = get_all_grammars(),
  callback = function() vim.treesitter.start() end,
})
-- }}}

-- {{{ Colorscheme

require("gruvbox").setup({
  italic = {
    strings = false,
    comments = false,
  },
  transparent_mode = true,
})
vim.cmd.colorscheme('gruvbox')
-- }}}

-- {{{ mini.nvim

-- Set some common options and keymappings.
-- Many of the above set options can be removed by this, see https://github.com/nvim-mini/mini.nvim/blob/main/lua/mini/basics.lua.
-- TODO: Add mappings for moving visual lines in insert mode, but remove mappings for normal mode.
require('mini.basics').setup({
  options = { extra_ui = true },
})
require('mini.bracketed').setup({
  undo = { suffix = '' },
  indent = { options = { change_type = "diff" } },
})

require('mini.notify').setup()
require('mini.icons').setup()
require('mini.git').setup()
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '┃', change = '┃', delete = '-' },
  }
})
require('mini.statusline').setup()

local miniclue = require('mini.clue')
miniclue.setup({
  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },

  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'i', keys = '<C-x>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  window = {
    config = {
      width = 50,
    },
  },
})

require('mini.pairs').setup()
require('mini.surround').setup({
  mappings = {
    add = 's', -- Add surrounding in Normal and Visual modes
    delete = 'ds', -- Delete surrounding
    replace = 'cs', -- Replace surrounding
    find = '', -- Find surrounding (to the right)
    find_left = '', -- Find surrounding (to the left)
    highlight = '', -- Highlight surrounding

    suffix_last = '', -- Suffix to search with "prev" method
    suffix_next = '', -- Suffix to search with "next" method
  },
  respect_selection_type = true,
})
-- }}}

-- [[ Other Plugins ]]

require('user.telescope')

require('toggleterm').setup({
  open_mapping = "<Leader>t",
  insert_mappings = false,
  terminal_mappings = false,
  persist_mode = false,
  shell =  "/run/current-system/sw/bin/fish",
})
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
