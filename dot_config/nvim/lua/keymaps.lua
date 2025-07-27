-- [ Keymaps ] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Turn off search highlights with <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Execute lua files
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<cr>', { desc = 'Execute current file' })
vim.keymap.set('n', '<leader>x', ':.lua<cr>', { desc = 'Execute current line' })
vim.keymap.set('v', '<leader>x', ':lua<cr>', { desc = 'Execute selection' })

-- Navigate between splits
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
