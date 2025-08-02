-- [ Autocommands ]
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("hl-yank", { clear = true }),
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  desc = "Save file when Neovim loses foucs",
  callback = function()
    vim.cmd "update"
  end,
})
