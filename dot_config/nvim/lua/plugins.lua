-- [ Plugins ]

local path_package = vim.fn.stdpath "data" .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd "packadd mini.nvim | helptags ALL"
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

require("mini.deps").setup { path = { package = path_package } }

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- mini.nvim
now(function()
  require("mini.statusline").setup()
end)

later(function()
  local miniclue = require "mini.clue"
  miniclue.setup {
    clues = {
      -- Leader clues
      { mode = "n", keys = "<Leader>d", desc = "[D]iagnostics" },
      { mode = "n", keys = "<Leader>s", desc = "[S]earch" },
      { mode = "n", keys = "<Leader>g", desc = "[G]it" },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },

    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },

    window = {
      config = { width = "auto" },
      delay = 500,
    },
  }
end)

later(function()
  require("mini.extra").setup()
  local pickers = MiniExtra.pickers
  vim.keymap.set("n", "<Leader>s.", pickers.oldfiles, { desc = "Search recent files" })
  vim.keymap.set("n", "<Leader>sd", pickers.diagnostic, { desc = "Search diagnostics" })
  vim.keymap.set("n", "<Leader>sk", pickers.keymaps, { desc = "Search keymaps" })
end)

later(function()
  require("mini.files").setup()
  local function minifiles_toggle()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end
  vim.keymap.set("n", "<Leader>e", minifiles_toggle, { desc = "Toggle file explorer" })
end)

later(function()
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end)

later(function()
  require("mini.indentscope").setup()
end)

later(function()
  require("mini.pairs").setup()
end)

later(function()
  require("mini.pick").setup()

  local builtin = MiniPick.builtin
  vim.keymap.set("n", "<Leader>sf", builtin.files, { desc = "Search files" })
  vim.keymap.set("n", "<Leader>sh", builtin.help, { desc = "Search help" })

  vim.keymap.set("n", "<Leader>sn", function()
    MiniPick.builtin.files({}, {
      source = { cwd = vim.fn.stdpath "config" },
    })
  end, { desc = "Search neovim configs" })
end)

-- Colorscheme
now(function()
  add { source = "catppuccin/nvim", name = "catppuccin" }
  vim.cmd "colorscheme catppuccin"
end)

-- Tree-sitter
later(function()
  add {
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
      post_checkout = function()
        vim.cmd "TSUpdate"
      end,
    },
  }

  require("nvim-treesitter").install {
    "bash",
    "c",
    "css",
    "fish",
    "gitcommit",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "vim",
    "vimdoc",
  }
end)

-- Installing language servers, debug adapters, linters and formatters
later(function()
  add "mason-org/mason.nvim"
  require("mason").setup()
end)

-- LSP Config
later(function()
  add "neovim/nvim-lspconfig"
  vim.lsp.enable {
    "basedpyright",
    "cssls",
    "emmet_language_server",
    "html",
    "ruff",
    "lua_ls",
  }

  -- Diagnostic Config
  vim.diagnostic.config {
    virtual_text = {
      source = "if_many",
      spacing = 2,
    },
  }

  -- Python
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end
      if client.name == "ruff" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end
    end,
    desc = "LSP: Disable hover capability from Ruff",
  })

  require("lspconfig").pyright.setup {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { "*" },
        },
      },
    },
  }
end)

-- LuaLS for Neovim
later(function()
  add "folke/lazydev.nvim"
  require("lazydev").setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  }
end)

-- Formatter
later(function()
  add "stevearc/conform.nvim"
  require("conform").setup {
    formatters_by_ft = {
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      lua = { "stylua" },
      python = { "ruff_fix", "ruff_formatter", "ruff_organize_imports" },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  }
end)

-- Autocompletion
later(function()
  add {
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    checkout = "v1.6.0",
  }

  require("blink.cmp").setup {
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
    keymap = { preset = "default" },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
  }
end)
