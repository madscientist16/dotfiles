-- [ Plugins ]

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Load immediately in a safe manner
now(function() require('mini.icons').setup() end)
now(function() require('mini.statusline').setup() end)

now(function()
  add({
    source = 'catppuccin/nvim',
    name = 'catppuccin'
  })
  require('catppuccin').setup({
    flavour = 'mocha',
    no_italic = true,
  })
  vim.cmd.colorscheme 'catppuccin'
end)

now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end }
  })
  require'nvim-treesitter.configs'.setup {
  ensure_installed = { 'c', 'lua', 'vimdoc', 'markdown', 'markdown_inline' },

  auto_install = true,

  highlight = { enable = true },
}
end)

now(function()
  add({
    source = 'nvim-telescope/telescope.nvim',
    checkout = '0.1.x',
    depends = { 'nvim-lua/plenary.nvim' },
  })
  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
end)

now(function()
  add({
    source = 'folke/todo-comments.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  })
end)
now(function() add({ source = 'tpope/vim-sleuth' }) end)

-- Load later in a safe manner
later(function() require('mini.comment').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)

later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      -- Built-in clues
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      -- Custom clues
      { mode = 'n', keys = '<Leader>s', desc = '[S]earch' },
      { mode = 'x', keys = '<Leader>s', desc = '[S]earch' },
      { mode = 'n', keys = 'dd', desc = 'Line' },
    },
    triggers = {
      -- Leader
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      -- Other
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = 'd' },
      { mode = 'n', keys = 's' },
      { mode = 'x', keys = 's' },
    },

    window = {
      config = {
        height = 10,
        width = 'auto',
        anchor = 'NE',
        row = 'auto',
        col = 'auto'
      },
      delay = 500,
    },
  })
end)
