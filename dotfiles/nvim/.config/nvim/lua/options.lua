local utils = require("custom.utils")
local icons = require("custom.icons")

vim.cmd([[syntax on]])

vim.cmd([[filetype plugin indent on]])

-- Global variables
local global = {
	-- Ignore the provider warnings
	loaded_perl_provider = 0,
	loaded_ruby_provider = 0,
	loaded_python3_provider = 0,
	loaded_node_provider = 0,

	editorconfig = true,

	-- Leader key mapping
	mapleader = ";",

	-- Disable tab key in copilot
	copilot_no_tab_map = true,

	-- Matchup
	matchup_matchparen_offscreen = { method = "popup" },
}

-- Vim based Options
local options = {
	-- Base
	-- Number of command-lines that are remembered
	history = 1000,

	-- Show (partial) command in status line
	showcmd = false,

	-- Briefly jump to matching bracket if insert one
	showmatch = true,

	-- Hide show current mode on status line
	showmode = false,

	-- Use a swapfile for the buffer
	swapfile = false,

	-- Copy the structure of the existing lines indent when autoindenting a new line
	copyindent = true,

	-- Split a window will put the new window below the current one
	splitbelow = true,
	-- split a window will put the new window right of the current one
	splitright = true,

	-- Use visual bell instead of beeping
	visualbell = true,

	-- Search case matching
	smartcase = true,
	ignorecase = true,

	-- Confirm before quite
	confirm = true,

	-- Number
	number = true,
	relativenumber = true,

	-- be iMproved, required
	compatible = false,

	-- Decrease update time
	updatetime = 200,

	-- Minimal number of screen lines to keep above and below the cursor
	scrolloff = 10,

	-- Folding
	foldenable = true,
	foldcolumn = "1", -- '0' is not bad
	foldlevel = 99, -- Using ufo provider need a large value, feel free to decrease the value
	foldlevelstart = 99,

	--  Count for the items in the menu popup
	pumheight = 15,

	-- Cursor line
	cursorline = true,

	-- Disable the native suggestion list, use `telescope.builtin.spell_suggest` instead
	spellsuggest = { 0 },

	-- Undo
	undofile = true,
	undolevels = 1000,

	-- Use the clipboard register "*" for all yank, delete, change and put operations
	clipboard = { "unnamedplus" },

	-- Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode
	backspace = { "indent", "eol", "start" },

	-- Ignore case when completing file names and directories
	wildignorecase = true,

	-- Diff Mode
	fillchars = { diff = "╱", foldclose = icons.get("extended", "arrowRight") },

	-- List Mode
	list = true,
	listchars = { tab = "> ", lead = "·", trail = "·" },

	-- Spaces of indent
	shiftwidth = 2,
	tabstop = 2,
	expandtab = true,

	-- Round indent to multiple of `shiftwidth`
	shiftround = true,

	-- Show command preview
	inccommand = "split",

	-- Default `rounded` style border for the floating window
	winborder = "rounded",
}

-- Custom filetypes
--- @type vim.filetype.add.filetypes
local filetypes = {
	extension = {
		json = "jsonc",
		tmux = "tmux",
		http = "http",
		sql = "sql",
	},
	filename = {
		[".gitignore"] = "conf",
		[".env"] = "dosini",
		Brewfile = "ruby",
	},
	pattern = {
		[".env.*"] = "dosini",
	},
}

utils.setup_options(options)

utils.setup_global(global)

utils.setup_filetypes(filetypes)
