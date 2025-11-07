local M = {}

---@param var string
---@param default? string
---@return string
local getenv = function(var, default)
	default = default or ""
	return os.getenv(var) or default or ""
end

M.LOCAL_PLUGINS_FOLDER = vim.fn.stdpath("config") .. "/lua/custom"

M.files = {
	vim = getenv("HOME") .. "/.vimrc",
	-- NeoVim initialization file
	nvim = getenv("XDG_CONFIG_HOME") .. "/nvim/init.lua",
	-- Folder saved snippets
	snippets = getenv("XDG_CONFIG_HOME") .. "/nvim/snippets",
	-- Tmux config
	tmux = getenv("XDG_CONFIG_HOME") .. "/tmux/tmux.conf",
	-- Kitty config
	ghostty = getenv("XDG_CONFIG_HOME") .. "/ghostty/config",
	-- ZSH config
	zsh = getenv("XDG_CONFIG_HOME") .. "/zsh/.zshrc",
	-- Aerospace config
	aerospace = getenv("XDG_CONFIG_HOME") .. "/aerospace/aerospace.toml",
	-- Dotfiles folder
	dotfiles = getenv("HOME") .. "/src/dotfiles",
	-- Obsidian Vault
	obsidian = getenv("OBSIDIAN_VAULT"),
}

M.colors = {
	RED = getenv("GUI_RED"),
	BLACK = getenv("GUI_BLACK"),
	GREEN = getenv("GUI_GREEN"),
	PRIMARY = getenv("GUI_BLUE"),
	BG = getenv("GUI_BACKGROUND"),
	FG = getenv("GUI_FOREGROUND"),
	DARK_RED = getenv("GUI_DARK_RED"),
	DARK_YELLOW = getenv("GUI_DARK_YELLOW"),
	VISUAL_GREY = getenv("GUI_VISUAL_GREY"),
	COMMENT_GREY = getenv("GUI_COMMENT_GREY"),
	SPECIAL_GREY = getenv("GUI_SPECIAL_GREY"),
}

M.filetype_mappings = setmetatable({
	jsonc = "JSON with comments",
	txt = "Plain Text",
	sql = "SQL",
	lua = "Lua",
	typescript = "TypeScript",
}, {
	__index = function(_, key)
		return key
	end,
})

local os_name = vim.uv.os_uname().sysname

M.os = {
	is_mac = os_name == "Darwin",
	is_linux = os_name == "Linux",
	is_windows = os_name == "Windows_NT",
	is_wsl = vim.fn.has("wsl") == 1,
}

M.os_sep = M.os.is_windows and "\\" or "/"

M.special_filetypes = {
	excluded_cowboy = {
		"lazy",
		"mason",
		"blame",
		"help",
		"noice",
		"http",
		"rest_nvim_result",
		"Avante",
		"oil",
	},
	excluded_winbar = {
		"git",
		"help",
		"packer",
		"rnvimr",
		"noice",
		"DiffviewFiles",
		"DiffviewFileHistory",
		"terminal",
		"blame",
		"oil",
		"dbee",
	},
	close_by_q = {
		"qf",
		"fzf",
		"man",
		"git",
		"help",
		"lspinfo",
		"startuptime",
		"null-ls-info",
		"git.nvim",
		"query",
		"notify",
	},
}

M.window_sizing = {
	md = {
		width = tonumber(vim.fn.getenv("WINDOW_VIEWPORT_WIDTH_MD")) or 0,
		height = tonumber(vim.fn.getenv("WINDOW_VIEWPORT_HEIGHT_MD")) or 0,
	},
}

---@enum ExternalType
M.external_type = {
	lsp = "LSP",
	formatter = "FORMATTER",
	linter = "LINTER",
}

---@class External
---@field external_type ExternalType
---@field mason? string
---@field config_file? string
---@field filetypes? string[]
---@field formatting? boolean

---@type table<string, External>
M.ensure_externals = {
	-- INFO: LSP
	html = {
		external_type = M.external_type.lsp,
		mason = "html-lsp",
	},
	cssls = {
		external_type = M.external_type.lsp,
		mason = "css-lsp",
	},
	bashls = {
		external_type = M.external_type.lsp,
		mason = "bash-language-server",
	},
	ruff = {
		external_type = M.external_type.lsp,
		mason = "ruff",
		config_file = "lsp.ruff-lsp",
	},
	pyrefly = {
		external_type = M.external_type.lsp,
		mason = "pyrefly",
	},
	tailwindcss = {
		external_type = M.external_type.lsp,
		mason = "tailwindcss-language-server",
	},
	jsonls = {
		external_type = M.external_type.lsp,
		mason = "json-lsp",
		config_file = "lsp.json-lsp",
	},
	ts_ls = {
		external_type = M.external_type.lsp,
		mason = "typescript-language-server",
		formatting = false,
	},
	gopls = {
		external_type = M.external_type.lsp,
		mason = "gopls",
	},
	lua_ls = {
		external_type = M.external_type.lsp,
		mason = "lua-language-server",
		config_file = "lsp.lua-lsp",
	},
	taplo = {
		external_type = M.external_type.lsp,
		mason = "taplo",
	},
	eslint = {
		external_type = M.external_type.lsp,
		mason = "eslint-lsp",
	},

	-- INFO: Formatters
	stylua = {
		external_type = M.external_type.formatter,
		mason = "stylua",
	},
	prettier = {
		external_type = M.external_type.formatter,
		mason = "prettier",
	},
}

return M
