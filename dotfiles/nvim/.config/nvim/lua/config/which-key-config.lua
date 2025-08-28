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

--- Telescope wrapper with theme flag based on the window sizing
---@param sub_cmd string
---@param opts table|nil
local telescope = function(sub_cmd, opts)
	return function()
		utils.telescope(sub_cmd, opts)
	end
end

--- @param curr_file boolean|nil
---@return function
local toggle_file_diff = function(curr_file)
	return function()
		if vim.bo.filetype == "DiffviewFileHistory" then
			vim.cmd("tabclose")
		else
			utils.change_cwd()
			vim.cmd("DiffviewFileHistory" .. (curr_file == true and " %" or ""))
		end
	end
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

--- INFO: Help
wk.add(withTrigger({
	{
		"h",
		group = "Help",
		{ "hc", utils.snacks_picker.commands, desc = "[C]ommands" },
		{ "hk", utils.snacks_picker.keymaps, desc = "[K]ey Maps" },
		{ "hh", utils.snacks_picker.highlights, desc = "[H]ighlight Groups" },
		{ "hm", t("Mason"), desc = "[M]ason Manager" },
		{
			"hl",
			name = "Lazy Manager",
			{ "hlS", t("Lazy sync"), desc = "[S]ync Plugins" },
			{ "hls", t("Lazy show"), desc = "[S]how Plugins" },
		},
		{ "hu", utils.snacks_picker.undo, desc = "[U]ndo tree" },
		{ "h?", utils.snacks_picker.help, desc = "Help doc" },
	},
	{ "/", utils.snacks_picker.lines, desc = "Search" },
}))

--- INFO: Buffer
wk.add(withTrigger({
	{ "b", group = "Buffer" },
	{
		"bb",
		function()
			utils.snacks_picker.buffers({
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
		{ "gc", utils.snacks_picker.git_log, desc = "Git [C]ommits" },
		{ "gC", utils.change_cwd, desc = "[C]hange Current Working Dir" },
		{ "gf", utils.snacks_picker.git_files, desc = "Git [F]iles" },
		{ "gh", toggle_file_diff(true), desc = "Current File [H]istory" },
		{ "gH", toggle_file_diff(), desc = "File [H]istory" },
	},
}))

--- INFO: Files Operation
wk.add(withTrigger({
	{ "f", group = "Files" },
	{ "fr", utils.snacks_picker.grep, desc = "Live G[r]ep" },
	{
		"ff",
		telescope("find_files", { no_ignore = true, hidden = true }),
		desc = "[F]ind files",
	},
	{ "fo", utils.snacks_picker.recent, desc = "Recently [O]pend" },
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
	{ "ls", utils.snacks_picker.lsp_symbols, desc = "Document [S]ymbols" },
	{ "lD", telescope("diagnostics"), desc = "Document [D]iagnostic" },
	{ "ld", t("lua vim.diagnostic.open_float({ source = true })"), desc = "Hover [D]iagnostic" },
	{ "lh", toggle_inlay_hint, desc = "Toggle Inlay [H]int" },
}))
