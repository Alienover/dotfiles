local utils = require("custom.utils")
local icons = require("custom.icons")

vim.cmd([[syntax on]])

vim.cmd([[filetype plugin indent on]])

-- Italic support
vim.cmd([[
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
]])

-- Global variables
local global = {
	-- Disable the builtin vim plugins
	loaded_gzip = 1,
	loaded_tar = 1,
	loaded_tarPlugin = 1,
	loaded_zip = 1,
	loaded_zipPlugin = 1,

	loaded_getscript = 1,
	loaded_getscriptPlugin = 1,
	loaded_vimball = 1,
	loaded_vimballPlugin = 1,
	loaded_2html_plugin = 1,

	-- Disable the builtin NetRW plugin
	loaded_netrw = 1,
	loaded_netrwPlugin = 1,
	loaded_netrwSettings = 1,
	loaded_netrwFileHandlers = 1,

	-- Disable the builtin `matchit.vim`
	loaded_matchit = 1,
	loaded_matchparen = 1,
	loaded_logiPat = 1,
	loaded_rrhelper = 1,

	loaded_sql_completion = 1,

	-- Disble Perl support
	loaded_perl_provider = 0,
	-- Disble Ruby support
	loaded_ruby_provider = 0,

	editorconfig = true,

	-- Leader key mapping
	mapleader = ";",

	-- Disable tab key in copilot
	copilot_no_tab_map = true,

	-- Matchup
	matchup_matchparen_offscreen = { method = "popup" },

	-- Python for neovim
	python_venv_home = os.getenv("VIRTUALENVWRAPPER_HOOK_DIR") .. "/neovim_py2",
	python3_venv_home = os.getenv("VIRTUALENVWRAPPER_HOOK_DIR") .. "/neovim_py3",
}

local python_venv_bin = global.python_venv_home .. "/bin/python"
local python3_venv_bin = global.python3_venv_home .. "/bin/python"

if vim.fn.executable(python_venv_bin) then
	global.python_host_prog = python_venv_bin
end

if vim.fn.executable(python3_venv_bin) then
	global.python3_host_prog = python3_venv_bin
end

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
	clipboard = { "unnamed" },

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
		Brewfile = "ruby",
	},
}

utils.setup_options(options)

utils.setup_global(global)

utils.setup_filetypes(filetypes)
