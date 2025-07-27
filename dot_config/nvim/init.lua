-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [ Options ]
require 'options'

-- [ Keymaps ]
require 'keymaps'

-- [ Autocommands ]
require 'autocmds'

-- [ Plugins ]
require 'plugins'
