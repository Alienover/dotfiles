local utils = require("custom.utils")
local constants = require("custom.constants")

local wk = require("which-key")

local WK_DEFAULT_PREFIX = "<space>"

wk.setup({
	---@type false | "classic" | "modern" | "helix"
	preset = false,

	---@type wk.Win.opts
	win = {
		width = vim.o.columns > 200 and 0.4 or 0.6,
		col = 0.5,
		---@type 'none' | 'rounded'
		border = "none",
	},
	layout = {
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 5, -- spacing between columns
	},

	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		spelling = {
			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
		},
		presets = {
			operators = true, -- adds help for operators like d, y, ...
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "", -- symbol used between a key and it's label
		group = "＋", -- symbol prepended to a group
	},
	show_help = true,
	disable = {
		-- disable WhichKey for certain buf types and file types.
		ft = {},
		bt = {},
	},
	triggers = {
		{ WK_DEFAULT_PREFIX, mode = { "n", "v" } },
		{ "<leader>", mode = { "n", "v" } },
		{ "[", mode = { "n" } },
		{ "]", mode = { "n" } },
	},
})

-- Populate the vim cmd prefix and suffix
---@param str string
---@param opts table|nil
local t = function(str, opts)
	return function()
		local silent = (opts and opts.silent) or false
		if silent then
			vim.F.npcall(vim.cmd, str)
		else
			vim.cmd(str)
		end
	end
end

-- Populate the command for file to edit
---@param filepath string
local e = function(filepath)
	return t("e " .. filepath)
end

local toggle_inlay_hint = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local enabled = vim.lsp.inlay_hint.is_enabled({
		bufnr = bufnr,
	})

	vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end

--- comment
--- @param mappings wk.Spec
--- @param trigger string?
local function withTrigger(mappings, trigger)
	trigger = trigger or WK_DEFAULT_PREFIX

	for idx, mapping in ipairs(mappings) do
		if idx == 1 and type(mapping) == "string" then
			mappings[idx] = trigger .. mapping
		elseif type(mapping) == "table" then
			mappings[idx] = withTrigger(mapping, trigger)
		else
			mappings[idx] = mapping
		end
	end

	return mappings
end

--- @module 'snacks'

--- INFO: Help
wk.add(withTrigger({
	{
		"h",
		group = "Help",
		{ "hc", Snacks.picker.commands, desc = "[C]ommands" },
		{ "hk", Snacks.picker.keymaps, desc = "[K]ey Maps" },
		{ "hh", Snacks.picker.highlights, desc = "[H]ighlight Groups" },
		{ "hm", t("Mason"), desc = "[M]ason Manager" },
		{
			"hl",
			name = "Lazy Manager",
			{ "hlS", t("Lazy sync"), desc = "[S]ync Plugins" },
			{ "hls", t("Lazy show"), desc = "[S]how Plugins" },
		},
		{ "hu", Snacks.picker.undo, desc = "[U]ndo tree" },
		{ "h?", Snacks.picker.help, desc = "Help doc" },
	},
	{ "/", Snacks.picker.lines, desc = "Search" },
}))

--- INFO: Buffer
wk.add(withTrigger({
	{ "b", group = "Buffer" },
	{
		"bb",
		function()
			Snacks.picker.buffers({
				on_show = function()
					vim.cmd.stopinsert()
				end,
				layout = "ivy",
			})
		end,
		desc = "Find [B]uffers",
	},
	{ "bn", t("tabnew"), desc = "[N]ew Tab" },
}))

--- INFO: Git
wk.add(withTrigger({
	{
		"g",
		group = "Git",
		mode = "n",
		{ "gc", Snacks.picker.git_log, desc = "Git [C]ommits" },
		{ "gC", utils.change_cwd, desc = "[C]hange Current Working Dir" },
		{ "gf", Snacks.picker.git_files, desc = "Git [F]iles" },
	},
}))

--- INFO: Files Operation
wk.add(withTrigger({
	{ "f", group = "Files" },
	{ "fr", Snacks.picker.grep, desc = "Live G[r]ep" },
	{
		"ff",
		function()
			Snacks.picker.files({ hidden = true, ignored = true })
		end,
		desc = "[F]ind files",
	},
	{ "fo", Snacks.picker.recent, desc = "Recently [O]pend" },
}))

--- INFO: Open File
wk.add(withTrigger({
	{ "o", group = "Open" },
	{ "ov", e(constants.files.vim), desc = ".vimrc" },
	{ "oz", e(constants.files.zsh), desc = ".zshrc" },
	{ "ot", e(constants.files.tmux), desc = ".tmux.conf" },
	{ "on", e(constants.files.nvim), desc = "init.lua" },
	{ "og", e(constants.files.ghostty), desc = "ghostty conf" },
	{ "oa", e(constants.files.aerospace), desc = "aerospace.toml" },
}))

--- INFO: LSP
wk.add(withTrigger({
	{ "l", group = "LSP" },
	{ "lI", t("LspInfo"), desc = "[I]nfo" },
	{ "lR", t("LspRestart"), desc = "[R]estart" },
	{ "lN", t("NullLsInfo"), desc = "[N]ull-ls Info" },
	{ "lf", t("lua vim.lsp.buf.format({async = true})"), desc = "[F]ormat" },
	{ "ls", Snacks.picker.lsp_symbols, desc = "Document [S]ymbols" },
	{ "ld", t("lua vim.diagnostic.open_float({ source = true })"), desc = "Hover [D]iagnostic" },
	{ "lh", toggle_inlay_hint, desc = "Toggle Inlay [H]int" },
}))
