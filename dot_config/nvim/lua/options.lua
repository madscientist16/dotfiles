-- [ Options ]
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.list = true
vim.o.listchars = "tab:» ,trail:·,nbsp:␣"
vim.o.confirm = true
vim.o.undofile = true -- Save undo history
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = "split" -- Substitute preview
vim.o.showmode = false -- Disabled because it's visibile on mini.statusline
vim.o.signcolumn = "yes:1"
vim.o.winborder = "rounded"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.breakindent = true -- Indent wrapped lines

-- Sync system clipboard
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)
