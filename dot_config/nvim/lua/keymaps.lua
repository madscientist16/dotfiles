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
vim.keymap.set("n", "<leader>ta", function()
  if not vim.b.autosave then
    vim.b.autosave = true
    vim.notify "Autosave on"
  else
    vim.b.autosave = false
    vim.notify "Autosave off"
  end
end, { desc = "Toggle autosave" })

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

-- Execute lua code
vim.keymap.set("n", "<leader><leader>x", "<cmd>source<CR>", { desc = "Execute file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Execute current line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Execute selection" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open quickfix list" })
vim.keymap.set({ "n", "x", "i" }, "<C-s>", "<Esc>:update<CR>", { desc = "Save file" })

-- [ Disabled ]
-- Disable the keymap for 's' because it interferes with mini.surround
vim.keymap.set({ "n", "x" }, "s", "<Nop>")
