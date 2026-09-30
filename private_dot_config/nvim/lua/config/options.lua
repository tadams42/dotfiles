-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- vim.print(vim.api.nvim_get_runtime_file('', true))
-- vim.print(vim.env.PATH)

vim.g.mapleader = ","

-- Ignore TERM and always emit 24b colors
vim.opt.termguicolors = true

-- When writing a file and this option is on, <EOL> at the end of file will be restored
-- if missing.
vim.opt.fixendofline = true

require("config.old_vim_options")

require("config.plugin_language_providers")

require("config.neovide")

require("config.python")

require("config.snacks")
