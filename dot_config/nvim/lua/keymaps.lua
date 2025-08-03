-- [ Keymaps ]
-- Turn off search highlights with <Esc>
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- Execute lua code
vim.keymap.set("n", "<Leader><Leader>x", "<Cmd>source<CR>", { desc = "Execute file" })
vim.keymap.set("n", "<Leader>x", ":.lua<CR>", { desc = "Execute current line" })
vim.keymap.set("v", "<Leader>x", ":lua<CR>", { desc = "Execute selection" })

-- Navigate between splits
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Open quickfix list
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open quickfix list" })

-- Toggle autosave
vim.keymap.set("n", "<leader>ta", function()
  if not vim.b.autosave then
    vim.b.autosave = true
    vim.notify "Autosave on"
  else
    vim.b.autosave = false
    vim.notify "Autosave off"
  end
end, { desc = "Toggle autosave" })
