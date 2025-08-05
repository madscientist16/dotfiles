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
-- Toggle autosave
vim.keymap.set("n", "<Leader>ta", function()
  if not vim.b.autosave then
    vim.b.autosave = true
    vim.notify "Autosave on"
  else
    vim.b.autosave = false
    vim.notify "Autosave off"
  end
end, { desc = "Toggle autosave" })

-- Toggle wrap
vim.keymap.set("n", "<Leader>tw", function() vim.o.wrap = not vim.o.wrap end, { desc = "Toggle wrap" })

-- [ Other ]
-- Turn off search highlights with <Esc>
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- Execute lua code
vim.keymap.set("n", "<Leader><Leader>x", "<Cmd>source<CR>", { desc = "Execute file" })
vim.keymap.set("n", "<Leader>x", ":.lua<CR>", { desc = "Execute current line" })
vim.keymap.set("v", "<Leader>x", ":lua<CR>", { desc = "Execute selection" })

-- Open quickfix list
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, { desc = "Open quickfix list" })

-- Save file
vim.keymap.set({ "n", "v", "i" }, "<C-s>", "<Esc>:update<CR>", { desc = "Save file" })

-- [ Disabled ]
-- Disable s key because it interferes with mini.surround
vim.keymap.set({ "n", "x" }, "s", "<Nop>")
