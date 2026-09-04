local M = {}

---@param var string
---@param default? string
---@return string
local getenv = function(var, default)
	default = default or ""
	return os.getenv(var) or default or ""
end

M.files = {
	-- NeoVim initialization file
	nvim = getenv("XDG_CONFIG_HOME") .. "/nvim/init.lua",
	-- Tmux config
	tmux = getenv("XDG_CONFIG_HOME") .. "/tmux/tmux.conf",
	-- Alacritty config
	alacritty = getenv("XDG_CONFIG_HOME") .. "/alacritty/alacritty.toml",
	-- ZSH config
	zsh = getenv("HOME") .. "/.zshrc",
	-- Aerospace config
	aerospace = getenv("XDG_CONFIG_HOME") .. "/aerospace/aerospace.toml",
	-- Obsidian Vault
	obsidian = getenv("OBSIDIAN_VAULT"),
}

M.filetype_mappings = setmetatable({
	json = "JSON",
	jsonc = "JSON with comments",
	txt = "Plain Text",
	sql = "SQL",
	lua = "Lua",
	python = "Python",
	javascript = "JavaScript",
	javascriptreact = "JavaScript",
	typescript = "TypeScript",
	typescriptreact = "TypeScript",
}, {
	__index = function(_, key)
		return key
	end,
})

-- INFO: shared with `tmux-popup`, but only exported by a login shell. The
-- fallbacks matter: without them the thresholds are 0, no viewport is ever
-- "small", and every float renders at 50% instead of 80%.
M.window_sizing = {
	md = {
		width = tonumber(vim.fn.getenv("WINDOW_VIEWPORT_WIDTH_MD")) or 270,
		height = tonumber(vim.fn.getenv("WINDOW_VIEWPORT_HEIGHT_MD")) or 80,
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
	},
	ty = {
		external_type = M.external_type.lsp,
		mason = "ty",
	},
	tailwindcss = {
		external_type = M.external_type.lsp,
		mason = "tailwindcss-language-server",
	},
	jsonls = {
		external_type = M.external_type.lsp,
		mason = "json-lsp",
	},
	ts_ls = {
		external_type = M.external_type.lsp,
		mason = "typescript-language-server",
	},
	lua_ls = {
		external_type = M.external_type.lsp,
		mason = "lua-language-server",
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
