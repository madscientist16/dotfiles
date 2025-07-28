-- [ Plugins ]

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath 'data' .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

-- Set up 'mini.deps'
require('mini.deps').setup { path = { package = path_package } }

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- mini.nvim
now(function()
  require('mini.statusline').setup()
end)

later(function()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    clues = {
      -- enhance this by adding descriptions for <leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),

      -- Leader clues
      { mode = 'n', keys = '<Leader>s', desc = '[S]earch' },
    },

    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    window = {
      config = {
        anchor = 'NE',
        row = 'auto',
        col = 'auto',
        width = 'auto',
      },

      delay = 500,
    },
  }
end)

later(function()
  require('mini.icons').setup()
  MiniIcons.mock_nvim_web_devicons()
end)

later(function()
  require('mini.indentscope').setup()
end)

-- Colorscheme
now(function()
  add { source = 'catppuccin/nvim', name = 'catppuccin' }
  vim.cmd 'colorscheme catppuccin'
end)

-- Tree-sitter
later(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function()
        vim.cmd 'TSUpdate'
      end,
    },
  }

  require('nvim-treesitter').install {
    'c',
    'css',
    'html',
    'javascript',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'vim',
    'vimdoc',
  }
end)

-- Installing LSPs, DAPs, linters and formatters
later(function()
  add 'mason-org/mason.nvim'
  require('mason').setup()
end)

-- Formatting
later(function()
  add 'stevearc/conform.nvim'
  require('conform').setup {
    formatters_by_ft = {
      css = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      lua = { 'stylua' },
      python = { 'autopep8' },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  }
end)

-- LSP Config
later(function()
  add 'neovim/nvim-lspconfig'
  vim.lsp.enable {
    'basedpyright',
    'emmet_language_server',
    'lua_ls',
  }

  -- Diagnostic Config
  vim.diagnostic.config {
    virtual_text = {
      source = 'if_many',
      spacing = 2,
    },
  }
end)

-- LuaLS for Neovim
later(function()
  add 'folke/lazydev.nvim'
  require('lazydev').setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }
end)

-- Autocompletion
later(function()
  add {
    source = 'saghen/blink.cmp',
    depends = { 'rafamadriz/friendly-snippets' },
    checkout = 'v1.6.0',
  }

  require('blink.cmp').setup {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  }
end)

-- Telescope (Fuzzy Finder)
later(function()
  local function build(args)
    vim.system({ 'make', '-C', args.path }, { text = true }):wait()
  end

  add {
    source = 'nvim-telescope/telescope.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      {
        source = 'nvim-telescope/telescope-fzf-native.nvim',
        hooks = {
          post_install = build,
          post_checkout = build,
        },
      },
    },
  }

  -- Add keymaps for telescope
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<Leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<Leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<Leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
  vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
end)
