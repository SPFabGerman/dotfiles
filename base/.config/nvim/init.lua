-- This configuration is not strictly standalone.
-- Plugins are installed through NixOS and this configuration assumes all necessary plugins are already available.
-- There are no fallbacks and no automatic installation of missing plugins.
-- In particular we heavily rely on mini.nvim for many common editing features and nvim-lspconfig and nvim-treesitter for LSP and TreeSitter configurations.
-- (For a list of all installed plugins see [nixos/programs.nix].)

-- Set some common options and keymappings.
require('mini.basics').setup({
  options = { extra_ui = true },
})
local toogle_prefix_key = MiniBasics.config.mappings.option_toggle_prefix

-- Setup MiniKeymap early to allow for some better key mappings
require('mini.keymap').setup()

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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', precedes = '❮', extends = '❯' }

-- Highlight line breaks and respect list indentation
-- (WIP: Is there a way to also show and respect comment string?)
vim.o.showbreak = "❯ "
vim.o.breakindentopt = 'list:-1,shift:-2'

-- Use already opened buffers when switching to a file (for example with `<C-w>f`).
vim.o.switchbuf = 'useopen'

-- Default fold method. This is overwritten if TreeSitter is activated or by some FTPlugins.
vim.o.foldmethod = 'indent'
vim.o.foldlevel = vim.o.foldnestmax -- By default nothing is folded

-- Allow concealing or visual replacement of text (defined by syntax highlighting)
vim.o.conceallevel = 2

-- Treat camelCased words as different words in spell checking
vim.o.spelloptions = 'camel'

-- Extend word completion by spellcheck (if `spell` is enabled)
vim.o.complete = '.,w,b,kspell'

-- Make popupmenu and floating windows opaque.
-- On some terminal emulators (e.g. kitty) transparency can prevent icons from being displayed in full width.
vim.o.pumblend = 0
vim.o.winblend = 0

-- Better indentation and tab lengths
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s).
vim.o.confirm = true

-- FTPlugins
vim.g.markdown_folding = 1
-- }}}

-- {{{ Basic Keymaps
-- mini.basic sets keybindings for normal mode that I don't want.
vim.keymap.del({ 'n', 'x' }, 'j')
vim.keymap.del({ 'n', 'x' }, 'k')
vim.keymap.del('n', 'gO')

-- Use display movements in insert mode
-- TODO: This breaks builtin completion.
-- vim.keymap.set('i', '<Up>', '<c-o>gk')
-- vim.keymap.set('i', '<Down>', '<c-o>gj')

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
require('lazydev').setup() -- Setup Lua LSP for Neovim
vim.lsp.enable('lua_ls')

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true, -- Show diagnostic messages at end of line
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '󰀪',
      [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
})

-- Setup some additional keybindings for LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-custom-keybindings-setup', { clear = true }),
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    -- Inlay Hints are disabled by default, but can be toggled with the following keybinding.
    if client:supports_method('textDocument/inlayHint', event.buf) then
      vim.keymap.set('n', toogle_prefix_key .. 'H', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, { buffer = event.buf, desc = 'Toggle Inlay Hints' })
    end
  end,
})
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

-- Enable highlighting and folding using TreeSitter
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('tree-sitter-startup', { clear = true }),
  -- See https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md for a list of supported languages.
  -- pattern = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'go', 'rust', 'python' },
  pattern = get_all_grammars(),
  callback = function()
    vim.treesitter.start()
    -- Setup folding using TreeSitter, if FTPlugin doesn't define it's own custom way.
    if vim.wo[0][0].foldexpr == vim.go.foldexpr and vim.wo[0][0].foldmethod == vim.go.foldmethod then
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
    end
  end,
})
-- }}}

-- {{{ Colorscheme
require("gruvbox").setup({
  italic = {
    strings = false,
    comments = false,
  },
})
vim.cmd.colorscheme('gruvbox')
-- }}}

-- {{{ mini.nvim
require('mini.extra').setup()
require('mini.misc').setup()
MiniMisc.setup_auto_root()
MiniMisc.setup_termbg_sync()

require('mini.bracketed').setup()
-- I prefer mini.indentscope over snacks.indent and snacks.scope.
-- The TreeSitter support they offer is not as intuitive as one might think and doesn't always work well for every language. (Also lacking a way to disable it on a per language basis.)
-- And it offers little practical advantage over just using the indent or the standard builtin block motions, especially for code that is properly formatted.
require('mini.indentscope').setup({ options = { try_as_border = true } })
-- {{{ Indentscope Python
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('mini-indentscope-python', { clear = true }),
  pattern = { 'python' },
  callback = function(event) vim.b[event.buf].miniindentscope_config = { options = { border = 'top' } } end
})
-- }}}

require('mini.pairs').setup({ modes = { command = true } })
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
})
--- }}}

-- NOTE: SplitJoin itself only uses simple text processing for doing the splits.
-- This works reasonably well for most common cases, but can fail in some edge cases.
-- A more accurate alternative may be to use a plugin for semantic processing with TreeSitter.
-- WARN: Also be careful when comments are interlined. These are often not handled correctly.
require('mini.splitjoin').setup({ mappings = { toggle = 'gs' } })
-- {{{ SplitJoin Lua
-- TODO: Maybe add a way to split single-line functions across multiple lines?
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('mini-splitjoin-lua', { clear = true }),
  pattern = { 'lua' },
  callback = function(event)
    vim.b[event.buf].minisplitjoin_config = {
      split = { hooks_post = { MiniSplitjoin.gen_hook.add_trailing_separator({ brackets = { '%b{}' } }) } },
      join  = { hooks_post = { MiniSplitjoin.gen_hook.del_trailing_separator({ brackets = { '%b{}' } }), MiniSplitjoin.gen_hook.pad_brackets({ brackets = { '%b{}' } }) } },
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
  group = vim.api.nvim_create_augroup('mini-splitjoin-nix', { clear = true }),
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
      join  = { hooks_post = { MiniSplitjoin.gen_hook.pad_brackets({ brackets = { '%b[]' } }) } },
    }
  end
})
-- }}}

require('mini.align').setup({
-- {{{ Align Setup
  modifiers = {
    -- I don't like the fact that default trimming tries to keep indentation on all lines.
    -- I think it is more intuitive if it were to only keep lowest indentation.
    ['t'] = function(steps, _)
      table.insert(steps.pre_justify, MiniAlign.gen_step.trim('both', 'low'))
    end,
    -- Add support for default latex separator, based on how = sign is handled
    ['&'] = function(steps, opts)
      opts.split_pattern = '&'
      table.insert(steps.pre_justify, MiniAlign.gen_step.trim('both', 'low'))
      opts.merge_delimiter = ' '
    end,
  }
})
-- }}}

require('mini.snippets').setup({ mappings = { jump_next = '<Tab>', jump_prev = '<S-Tab>' } })
require('mini.completion').setup({
  -- {{{ Completion Setup
  lsp_completion = {
    -- Setup LSP completion through omnifunc, but only setup when LSP is actually available.
    -- This keeps both user completion and omni completion through filetype plugins available as a fallback.
    source_func = 'omnifunc',
    auto_setup = false,
  },
})
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' }) -- Fix <CR> mappings for use in completion and pairs
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() }) -- Advertise extra LSP capabilities through mini.completion.

-- Overwrite default LSP completion using mini.completion.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('mini-completion-lsp', { clear = true }),
  callback = function(event) vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})
-- }}}

require('mini.jump2d').setup({ view = { dim = true, n_steps_ahead = 3 } })
-- vim.keymap.set('n', '<Leader>j', function() minijump.start(minijump.builtin_opts.word_start) end, { desc = 'Jump' })
vim.keymap.set('n', '<CR>', function() MiniJump2d.start(MiniJump2d.builtin_opts.single_character) end, { desc = 'Jump to char' })

require('mini.git').setup()
require('mini.diff').setup({ view = { style = 'sign', priority = 1, signs = { add = '┃', change = '┃', delete = '-' } } })

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

require('mini.statusline').setup()
-- WIP: I kind of like the UI of snacks.notifier more than that of mini.notify. But it doesn't have builtin LSP notifications (and I don't want to add a custom one into my own config).
-- A good compromise could be to use Snacks.notifier together with something like fidget.nvim for LSP notifications.
-- But then again, notifications happen only rarely enough that it doesn't really matter.
require('mini.notify').setup({
  -- {{{ Notify Setup
  content = {
    sort = function(notif_arr)
      local predicate = function(notif)
        -- Filter out some LSP progress notifications from 'lua_ls'
        -- Code comes from https://github.com/echasnovski/nvim/blob/ed2c21491dea0de864df2eb9d3a588adf9175fad/plugin/30_mini.lua#L32
        if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
        return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
      end
      return require('mini.notify').default_sort(vim.tbl_filter(predicate, notif_arr))
    end,
  },
})
-- }}}

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
    { mode = 'n', keys = toogle_prefix_key }
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
    high = MiniExtra.gen_highlighter.words({ 'FIXME', 'BUG', 'ERR', 'ERROR' }, 'MiniHipatternsFixme'),
    medium = MiniExtra.gen_highlighter.words({ 'HACK', 'WARN', 'WARNING' }, 'MiniHipatternsHack'),
    todo = MiniExtra.gen_highlighter.words({ 'TODO', 'WIP' }, 'MiniHipatternsTodo'),
    low = MiniExtra.gen_highlighter.words({ 'NOTE', 'INFO', 'TIP' }, 'MiniHipatternsNote'),
    hex_color = hipatterns.gen_highlighter.hex_color(), -- #ffaa00
  }
})
-- }}}
-- }}}

-- {{{ Snacks.nvim
require('snacks').setup({
  picker = {
    enabled = true,
    win = {
      input = {
        keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } },
        b = { minicompletion_disable = true },
      },
    },
  },
  explorer = { enabled = true },
  input = {
    enabled = true,
    win = {
      keys = { i_esc = { "<esc>", { "cancel" }, mode = "i" } },
      b = { minicompletion_disable = true },
    },
  },

  -- BUG: Image plugin doesn't really work well with markdown math
  image = { enabled = true },
})

-- Picker keybindings
local picker = require('snacks').picker
vim.keymap.set('n', '<leader>h', picker.help, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>b', picker.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>f', picker.files, { desc = 'Files' })
vim.keymap.set('n', '<leader>e', picker.explorer, { desc = 'Explorer' })
vim.keymap.set('n', '<leader>r', picker.recent, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>s', picker.lines, { desc = 'Search' })
vim.keymap.set('n', '<leader>d', picker.diagnostics, { desc = 'Diagnostics' })

-- Use Picker for choosing LSP target instead of Quickfix list
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('snack-picker-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', picker.lsp_references, { buffer = buf, desc = 'Goto References' })
    vim.keymap.set('n', 'grd', picker.lsp_definitions, { buffer = buf, desc = 'Goto Definitions' })
    vim.keymap.set('n', 'gri', picker.lsp_implementations, { buffer = buf, desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gO', picker.lsp_workspace_symbols, { buffer = buf, desc = 'Workspace symbols' })
  end,
})
-- }}}

-- [[ Other Plugins ]]

-- WIP: Can in the future maybe be replaced by mini.terminal when it is implemented.
-- I tried replacing it with snack.terminal, but the results weren't really that good.
require('toggleterm').setup({
  open_mapping = "<Leader>t",
  insert_mappings = false,
  terminal_mappings = false,
  persist_mode = false,
  shell = "/run/current-system/sw/bin/fish",
})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Quick window commands' })

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker foldlevel=0
