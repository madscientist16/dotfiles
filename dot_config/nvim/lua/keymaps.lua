-- [ Keymaps ]
-- Turn off search highlights with <Esc>
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- Save and source current file
vim.keymap.set("n", "<Leader>x", "<Cmd>update | source<CR>", { desc = "Execute file" })
vim.keymap.set("v", "<Leader>x", ":lua<CR>", { desc = "Execute selection" })

-- Navigate between splits
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open [Q]uickfix list" })
