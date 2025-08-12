local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- [ Load now ]
-- Colorscheme
now(function()
  add { source = "catppuccin/nvim", name = "catppuccin" }
  vim.cmd.colorscheme "catppuccin"
end)

now(function()
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end)

now(function()
  require("mini.notify").setup()
  vim.notify = MiniNotify.make_notify()
end)

now(function() require("mini.statusline").setup() end)

-- Tree-sitter
now(function()
  add {
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = { post_checkout = function() vim.cmd "TSUpdate" end },
  }
  add { source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" }

  -- Install parsers and queries
  local parsers = {
    "bash",
    "css",
    "fish",
    "gitcommit",
    "html",
    "javascript",
    "lua",
    "markdown",
    "python",
  }
  require("nvim-treesitter").install(parsers)

  -- Enable highlighting
  local treesitter_group = vim.api.nvim_create_augroup("treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = treesitter_group,
    pattern = vim.iter(parsers):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    callback = function() vim.treesitter.start() end,
  })

  -- Enable indentation
  vim.api.nvim_create_autocmd("FileType", {
    group = treesitter_group,
    pattern = "python",
    callback = function() vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end,
  })
end)

-- [ Load later ]
later(function() require("mini.extra").setup() end)
later(function() require("mini.diff").setup() end)
later(function() require("mini.indentscope").setup() end)
later(function() require("mini.jump").setup() end)
later(function() require("mini.pairs").setup() end)
later(function() require("mini.surround").setup() end)

later(function()
  local miniclue = require "mini.clue"
  miniclue.setup {
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },

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
    clues = {
      -- Leader clues
      { mode = "n", keys = "<leader>d", desc = "[D]iagnostics" },
      { mode = "n", keys = "<leader>g", desc = "[G]it" },
      { mode = "n", keys = "<leader>s", desc = "[S]earch" },
      { mode = "n", keys = "<leader>t", desc = "[T]oggle" },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = { delay = 500 },
  }
end)

later(function()
  require("mini.files").setup()
  vim.keymap.set("n", "<leader>e", function()
    if not MiniFiles.close() then MiniFiles.open() end
  end, { desc = "Toggle file explorer" })
end)

later(function()
  local hipatterns = require "mini.hipatterns"
  hipatterns.setup {
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    },
  }
end)

later(function()
  require("mini.pick").setup()
  local builtin, pickers = MiniPick.builtin, MiniExtra.pickers
  vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
  vim.keymap.set("n", "<leader>sf", builtin.files, { desc = "Search files" })
  vim.keymap.set("n", "<leader>sh", builtin.help, { desc = "Search help" })
  vim.keymap.set(
    "n",
    "<leader>sn",
    function()
      MiniPick.builtin.files({}, {
        source = { cwd = vim.fn.stdpath "config" },
      })
    end,
    { desc = "Search neovim configs" }
  )
  vim.keymap.set("n", "<leader>s.", pickers.oldfiles, { desc = "Search recent files" })
  vim.keymap.set("n", "<leader>sd", pickers.diagnostic, { desc = "Search diagnostics" })
  vim.keymap.set("n", "<leader>sk", pickers.keymaps, { desc = "Search keymaps" })
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
      python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
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
    -- depends = { "rafamadriz/friendly-snippets" },
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
