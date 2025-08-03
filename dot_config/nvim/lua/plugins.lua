local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- [ Load now ]
-- Colorscheme
now(function()
  add { source = "catppuccin/nvim", name = "catppuccin" }
  vim.cmd.colorscheme "catppuccin"
end)

-- Icons
now(function()
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end)

-- Notifications
now(function()
  require("mini.notify").setup()
  vim.notify = MiniNotify.make_notify()
end)

-- Statusline
now(function() require("mini.statusline").setup() end)

-- [ Load later ]
later(function() require("mini.pairs").setup() end)

later(function()
  local miniclue = require "mini.clue"
  miniclue.setup {
    clues = {
      -- Leader clues
      { mode = "n", keys = "<Leader>d", desc = "[D]iagnostics" },
      { mode = "n", keys = "<Leader>g", desc = "[G]it" },
      { mode = "n", keys = "<Leader>s", desc = "[S]earch" },
      { mode = "n", keys = "<Leader>t", desc = "[T]oggle" },

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
  vim.keymap.set("n", "<Leader>e", function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end, { desc = "Toggle file explorer" })
end)

later(function()
  require("mini.pick").setup()

  local builtin = MiniPick.builtin

  vim.keymap.set("n", "<Leader>sf", builtin.files, { desc = "Search files" })
  vim.keymap.set("n", "<Leader>sh", builtin.help, { desc = "Search help" })
  vim.keymap.set(
    "n",
    "<Leader>sn",
    function()
      MiniPick.builtin.files({}, {
        source = { cwd = vim.fn.stdpath "config" },
      })
    end,
    { desc = "Search neovim configs" }
  )
end)

later(function() require("mini.indentscope").setup() end)

-- Tree-sitter
later(function()
  add {
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
      post_checkout = function() vim.cmd "TSUpdate" end,
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

-- Install language servers, debug adapters, linters and formatters
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

-- Completion
later(function()
  add {
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    checkout = "v1.6.0",
  }
  require("blink.cmp").setup {
    completion = {
      menu = {
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon" }, { "kind" } },
        },
      },
    },
  }
end)
