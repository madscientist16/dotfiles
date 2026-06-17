-- =====================
-- SECTION 1: OPTIONS ==
-- =====================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- [ General ]
  vim.o.mouse = "a" -- Enable mouse
  vim.o.undofile = true -- Save undo history

  -- Sync clipboard between OS and Neovim
  vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

  -- [ UI ]
  vim.o.cursorline = true -- Highlight current line
  vim.o.breakindent = true -- Indent wrapped lines
  vim.o.showbreak = "↪ "
  vim.o.list = true
  vim.o.listchars = "tab:» ,trail:·,nbsp:␣"
  vim.o.number = true -- Show line numbers
  vim.o.relativenumber = true -- Show relative line numbers
  vim.o.scrolloff = 10 -- Number of lines to keep above/below cursor when scrolling
  vim.o.showmode = false -- Disabled since it's visible on the statusline
  vim.o.splitright = true -- Vertical split right
  vim.o.splitbelow = true -- Horizontal split below
  vim.o.wrap = false
  vim.o.winborder = "rounded"

  -- [ Editing ]
  vim.o.expandtab = true -- Convert tabs to spaces
  vim.o.shiftwidth = 4 -- Spaces to use for indentation
  vim.o.ignorecase = true -- Ignore case while searching
  vim.o.smartcase = true
  vim.o.inccommand = "split" -- Show preview during substitution

  -- [ Autocommands ]
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- =====================
-- SECTION 2: KEYMAPS ==
-- =====================
do
  -- [ Windows & Navigation ]
  -- Resize windows with CTRL + arrow keys
  vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "Decrease window width" })
  vim.keymap.set("n", "<C-Down>", "<C-w>-", { desc = "Decrease window height" })
  vim.keymap.set("n", "<C-Up>", "<C-w>+", { desc = "Increase window height" })
  vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "Increase window width" })

  -- Navigate between windows with CTRL + hjkl
  vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })

  -- Move cursor in insert mode with Alt + hjkl
  vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left" })
  vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down" })
  vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up" })
  vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right" })

  -- [ Toggles ]
  vim.keymap.set(
    "n",
    "<leader>tr",
    function() vim.o.relativenumber = not vim.o.relativenumber end,
    { desc = "Toggle relative line numbers" }
  )

  vim.keymap.set("n", "<leader>tw", function() vim.o.wrap = not vim.o.wrap end, { desc = "Toggle wrap" })

  -- [ Other ]
  -- Turn off search highlights with <Esc>
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open quickfix list" })
  vim.keymap.set({ "n", "x", "i" }, "<C-s>", "<Esc>:update<CR>", { desc = "Save file" })
end

-- =====================
-- SECTION 3: PLUGINS ==
-- =====================

-- Helper function for plugins hosted on GitHub
local function gh(repo) return "https://github.com/" .. repo end

do
  -- Runs after a plugin is installed or updated
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if kind ~= "install" and kind ~= "update" then return end

      if name == "nvim-treesitter" then
        if not ev.data.active then vim.cmd.packadd "nvim-treesitter" end
        vim.cmd "TSUpdate"
        return
      end
    end,
  })

  -- [ Colorscheme ]
  vim.pack.add { { src = gh "catppuccin/nvim", name = "catppuccin" } }
  vim.cmd.colorscheme "catppuccin-nvim"

  -- [ Tree-sitter]
  vim.pack.add { { src = gh "nvim-treesitter/nvim-treesitter", version = "main" } }

  -- Install parsers and queries
  local parsers = {
    "bash",
    "c",
    "diff",
    "fish",
    "gitcommit",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
  }
  require("nvim-treesitter").install(parsers)

  -- Enable highlighting
  local treesitter_group = vim.api.nvim_create_augroup("treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = treesitter_group,
    pattern = vim.iter(parsers):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    callback = function() vim.treesitter.start() end,
  })

  -- [ mini.nvim ]
  vim.pack.add { gh "nvim-mini/mini.nvim" }

  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()

  require("mini.indentscope").setup()
  require("mini.pairs").setup()
  require("mini.statusline").setup()
end
