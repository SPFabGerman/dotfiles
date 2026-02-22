-- This configuration is not strictly standalone.
-- Plugins are installed through NixOS and this configuration assumes all necessary plugins are already available.
-- There are no fallbacks and no automatic installation of missing plugins.
-- In particular we heavily rely on mini.nvim for many common editing features and nvim-lspconfig and nvim-treesitter for LSP and TreeSitter configurations.
-- (For a list of all installed plugins see [nixos/programs.nix].)

-- Set some common options and keymappings.
-- TODO: Add mappings for moving visual lines in insert mode, but remove mappings for normal mode.
require('mini.basics').setup({
  options = { extra_ui = true },
})

-- {{{ Extra Options
-- See `:help option-list`
vim.o.relativenumber = true

vim.o.title = true
vim.o.titlestring = "%t%( %M%)"

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

vim.o.winborder = "rounded"

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 3

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', precedes = '⇠', extends = '⇢' }

-- Better indentation and tab lengths
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s).
vim.o.confirm = true
-- }}}

-- {{{ Basic Keymaps
vim.keymap.set('n', 'U', '<C-R>')
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- This is better for a german keyboard layout
vim.keymap.set('n', ',', ';')
vim.keymap.set('n', ';', ',')

-- By default don't replace clipboard with replaced text when pasting in visual mode
vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'P', 'p')

-- vim.keymap.set('x', '<C-Up>', ":m-2<CR>gv=gv")
-- vim.keymap.set('x', '<C-Down>', ":m'>+1<CR>gv=gv")
-- vim.keymap.set('x', '=', '=gv')
-- vim.keymap.set('x', '<', '<gv')
-- vim.keymap.set('x', '>', '>gv')

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('closewithq', { clear = true }),
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function(event) vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, desc = 'Close window' }) end,
})
-- }}}

-- {{{ LSP
-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md for default configurations of LSP servers.

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true, -- Show diagnostic messages at end of line
  signs = { text = { [vim.diagnostic.severity.ERROR] = '', [vim.diagnostic.severity.WARN] = '' } },
  jump = { float = true }, -- Auto open the float on jumps
})

-- This is already mapped by Telescope.
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('lsp-extra-bindings', { clear = true }),
--   callback = function(event) vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'Goto Definition' }) end,
-- })

-- {{{ Lua LSP Setup for Neovim
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
-- }}}

vim.lsp.enable('lua_ls')
-- }}}

-- {{{ TreeSitter
-- NOTE: TreeSitter support is still considered experimental.
-- For more configuration options see https://github.com/nvim-treesitter/nvim-treesitter.

-- NOTE: Installation of TreeSitter Grammars is done by NixOS itself, because `:TSInstall` doesn't work correctly on NixOS.
-- We use this helper function to get a list of all installed grammars.
local function get_all_grammars()
  local f = vim.api.nvim_get_runtime_file('parser/*', true)
  local g = {}
  for k,v in pairs(f) do
    g[k] = v:match("^.*/(.*).so$")
  end
  return g
end

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
require('mini.bracketed').setup()
require('mini.indentscope').setup({
  options = { try_as_border = true },
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function(event) vim.b[event.buf].miniindentscope_config = { options = { border = 'top' } } end
})

require('mini.pairs').setup()
require('mini.surround').setup({
  --- {{{ Surround Setup
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
  --- }}}
})

-- NOTE: SplitJoin itself only uses simple text processing for doing the splits.
-- This works reasonably well for most common cases, but can fail in some edge cases.
-- A more accurate alternative may be to use a plugin for semantic processing with TreeSitter.
-- WARN: Also be careful when comments are interlined. These are often not handled correctly.
local minisplitjoin = require('mini.splitjoin')
minisplitjoin.setup({
  mappings = { toggle = 'gs' },
})
-- {{{ SplitJoin Lua
-- TODO: Can something for functions be added?
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function(event)
    vim.b[event.buf].minisplitjoin_config = {
      split = { hooks_post = { minisplitjoin.gen_hook.add_trailing_separator({ brackets = { '%b{}' } }) } },
      join  = { hooks_post = { minisplitjoin.gen_hook.del_trailing_separator({ brackets = { '%b{}' } }), minisplitjoin.gen_hook.pad_brackets({ brackets = { '%b{}' } }) } },
    }
  end
})
-- }}}
-- {{{ SplitJoin Nix
-- NOTE: In Nix set attributes are separated by ';'.
-- But Nix uses ';' generally more as an expression delimiter than a pure separator.
-- (Think for example in with or let expressions.)
-- This leads to many false positives, which is why we exclude set splits / joins in Nix.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'nix' },
  callback = function(event)
    vim.b[event.buf].minisplitjoin_config = {
      detect = {
        brackets = { '%b()', '%b[]' },
        -- Matches (multiple) spaces, excluding the starting ones in a list.
        -- (See https://github.com/nvim-mini/mini.nvim/issues/386.)
        -- Note also that only the end of the matched string is used for the split position.
        separator = '[^[]%f[ ] +',
      },
      join  = { hooks_post = { minisplitjoin.gen_hook.pad_brackets({ brackets = { '%b[]' } }) } },
    }
  end
})
-- }}}

local minijump = require('mini.jump2d')
minijump.setup({
  view = {
    dim = true,
    n_steps_ahead = 3,
  },
  mappings = { start_jumping = '' }
})
vim.keymap.set('n', '<Leader>j', function() minijump.start(minijump.builtin_opts.word_start) end, { desc = 'Jump' })
vim.keymap.set('n', '<Leader>J', function() minijump.start(minijump.builtin_opts.single_character) end, { desc = 'Jump to char' })

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()

require('mini.git').setup()
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '┃', change = '┃', delete = '-' },
    priority = 1,
  }
})

require('mini.statusline').setup()
require('mini.notify').setup()

local miniclue = require('mini.clue')
-- {{{ Mini.Clue Setup
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
    { mode = 'n', keys = require('mini.basics').config.mappings.option_toggle_prefix }
  },

  window = {
    config = {
      width = 50,
    },
  },
})
-- }}}

-- NOTE: In some languages these may already be highlighted by syntax highlighting (sometimes through TreeSitter).
-- This should overwrite the default syntax highlighting.
local hipatterns = require('mini.hipatterns')
-- {{{ HiPatterns Setup
hipatterns.setup({
  highlighters = {
    fixme     = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    bug       = { pattern = 'BUG', group = 'MiniHipatternsFixme' },
    err       = { pattern = 'ERROR', group = 'MiniHipatternsFixme' },
    hack      = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    warn      = { pattern = 'WARN', group = 'MiniHipatternsHack' },
    todo      = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    wip       = { pattern = 'WIP', group = 'MiniHipatternsTodo' },
    note      = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    info      = { pattern = 'INFO', group = 'MiniHipatternsNote' },
    hex_color = hipatterns.gen_highlighter.hex_color(), -- #ffaa00
  }
})
-- }}}
-- }}}

-- {{{ Telescope
require('telescope').setup({
  defaults = {
    mappings = {
      i = { ["<esc>"] = require('telescope.actions').close },
    },
  },
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_cursor() },
  },
})

require('telescope').load_extension('ui-select') -- Make builtin neovim actions use telescope
require('telescope').load_extension('fzf') -- Use fzf syntax for matching

local tsbuiltin = require('telescope.builtin')
vim.keymap.set('n', '<C-h>', tsbuiltin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>b', tsbuiltin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>f', tsbuiltin.find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>r', tsbuiltin.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>s', tsbuiltin.current_buffer_fuzzy_find, { desc = 'Search' })
vim.keymap.set('n', '<leader>d', tsbuiltin.diagnostics, { desc = 'Diagnostics' })

-- Use Telescope for choosing LSP target instead of Quickfix list
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', tsbuiltin.lsp_references, { buffer = buf, desc = 'Goto References' })
    vim.keymap.set('n', 'grd', tsbuiltin.lsp_definitions, { buffer = buf, desc = 'Goto Definitions' })
    vim.keymap.set('n', 'gri', tsbuiltin.lsp_implementations, { buffer = buf, desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gO', tsbuiltin.lsp_workspace_symbols, { buffer = buf, desc = 'Workspace symbols' })
  end,
})
-- }}}

-- [[ Other Plugins ]]

-- NOTE: Can in the future maybe be replaced by mini.terminal when it is implemented.
require('toggleterm').setup({
  open_mapping = "<Leader>t",
  insert_mappings = false,
  terminal_mappings = false,
  persist_mode = false,
  shell = "/run/current-system/sw/bin/fish",
})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Quick window commands' })

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
