-- [ Leader key ]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [ General ]
vim.o.mouse = "a" -- Enable mouse
vim.o.undofile = true -- Save undo history

-- Sync system clipboard
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

-- [ UI ]
vim.o.cursorline = true
vim.o.breakindent = true -- Indent wrapped lines
vim.o.list = true
vim.o.listchars = "tab:» ,trail:·,nbsp:␣"
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true
vim.o.scrolloff = 10 -- Number of lines above/below cursor when scrolling
vim.o.showmode = false -- Disabled since it's visible on the statusline
vim.o.signcolumn = "yes:1"
vim.o.splitright = true -- Vertical split right
vim.o.splitbelow = true -- Horizontal split below
vim.o.winborder = "rounded"

-- [ Editing ]
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.shiftwidth = 4 -- Spaces to use for indentation
vim.o.ignorecase = true -- Ignore case when searching
vim.o.smartcase = true
vim.o.inccommand = "split" -- Show preview during search & replace

-- [ Autocommands ]
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  desc = "Highlight when yanking (copying) text",
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  desc = "Autosave when neovim loses focus",
  callback = function(args)
    if vim.b.autosave and vim.bo.modifiable and vim.fn.filewritable(args.file) == 1 then vim.cmd.update() end
  end,
  nested = true, -- Without this, the file won't format on save
})

-- [ Diagnostics ]
vim.diagnostic.config {
  virtual_text = {
    source = "if_many",
    spacing = 2,
  },
}
