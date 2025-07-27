-- [ Options ] See `:h vim.o`
-- For more options, you can see `:help option-list`

-- Print the line number in front of each line
vim.o.number = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- Enable mouse
vim.o.mouse = 'a'

-- Save undo history
vim.o.undofile = true

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 4

-- Splits
vim.o.splitbelow = true

-- Substitution preview
vim.o.inccommand = 'split'

-- Don't show mode since it's visible on the statusline
vim.o.showmode = false
