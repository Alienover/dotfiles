vim.uv = vim.uv or vim.loop

-- Enables the experimental Lua module loader
if vim.loader then
	vim.loader.enable()
end

-- Ignore the deprecate warnings
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

-- Use custom select UI that is the Snacks picker with mods
vim.ui.select = require("util.select").select

-- Global variables
-- Ignore the provider warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.g.editorconfig = true

-- Leader key mapping
vim.g.mapleader = ";"

-- Matchup
vim.g.matchup_matchparen_offscreen = { method = "popup" }

-- Enable Cowboy by default
vim.g.cowboy_enabled = true

vim.g.clipboard = "osc52"

-- Vim based Options

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.showcmd = false -- Show (partial) command in status line
vim.opt.showmode = false -- Hide current mode on status line
vim.opt.showmatch = true -- Briefly jump to matching bracket when inserting one
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above/below the cursor
vim.opt.pumheight = 15 -- Count for the items in the menu popup
vim.opt.cmdheight = 0
vim.opt.winborder = "rounded" -- Default border style for floating windows
vim.opt.visualbell = true -- Use visual bell instead of beeping
vim.opt.list = true
vim.opt.listchars = { tab = "> ", lead = "·", trail = "·" }
vim.opt.fillchars = { diff = "╱" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true -- Ignore case when completing file names and directories

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true -- Round indent to multiple of `shiftwidth`
vim.opt.copyindent = true -- Copy the existing line's indent when autoindenting a new line

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Folding
vim.opt.foldenable = true
vim.opt.foldcolumn = "1" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99

-- Files & persistence
vim.opt.swapfile = false
vim.opt.undofile = true

-- Behavior
vim.opt.inccommand = "split" -- Show command preview
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard for all operations
