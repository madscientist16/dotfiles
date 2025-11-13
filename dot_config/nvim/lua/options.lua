-- [ Leader key ]
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
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  desc = "Highlight when yanking (copying) text",
  callback = function() vim.hl.on_yank() end,
})
