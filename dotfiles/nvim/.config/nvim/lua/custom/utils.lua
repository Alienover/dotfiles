local window_sizing = require("custom.constants").window_sizing

local M = {}

---@param mode string|table
---@param key string
---@param cmd string|function
---@param opts string|table|nil
M.map = function(mode, key, cmd, opts)
	if type(opts) == "string" then
		opts = { desc = opts }
	end

	opts = vim.tbl_deep_extend("force", { noremap = true, silent = true, desc = "User Keymap: " .. key }, opts or {})

	vim.keymap.set(mode, key, cmd, opts)
end

--- Populate the mode-preseted map func for `nmap`, `imap`, `tmap`, `vmap`, `smap`, `xmap`
for _, mode in ipairs({ "n", "i", "t", "v", "s", "x" }) do
	M[mode .. "map"] = function(...)
		M.map(mode, ...)
	end
end

---@return {columns: integer, lines: integer}
M.get_window_sepc = function()
	return {
		columns = vim.api.nvim_get_option_value("columns", {}),
		lines = vim.api.nvim_get_option_value("lines", {}),
	}
end

---@return {l: number, t: number}
M.get_window_default_spacing = function(width, height)
	local l, t = 0.25, 0.25
	local win_spec = M.get_window_sepc()

	width = width or win_spec.columns
	height = height or win_spec.lines

	if width <= window_sizing.md.width then
		l = 0.1
	end

	if height <= window_sizing.md.height then
		t = 0.1
	end

	return { l = l, t = t }
end

---@param args ?table
---@return vim.api.keyset.win_config
M.get_float_win_opts = function(args)
	args = args or {}
	local win_spec = M.get_window_sepc()
	local default_offset = M.get_window_default_spacing(win_spec.columns, win_spec.lines)

	local l_offset, t_offset = args.l_offset or default_offset.l, args.t_offset or default_offset.t

	local border = args.border
	args.border = nil

	---@diagnostic disable-next-line: return-type-mismatch
	return vim.tbl_deep_extend("force", {
		row = math.floor(t_offset * win_spec.lines),
		col = math.floor(l_offset * win_spec.columns),
		height = math.floor((1 - t_offset * 2) * win_spec.lines),
		width = math.floor((1 - l_offset * 2) * win_spec.columns),
		style = "minimal",
		relative = "editor",
		border = border and {
			"╭",
			"─",
			"╮",
			"│",
			"╯",
			"─",
			"╰",
			"│",
		},
	}, args)
end

---@return {width: number, height: number}
M.get_float_win_sizing = function()
	local spec = M.get_window_sepc()
	local win_opts = M.get_float_win_opts()

	return {
		width = tonumber(string.format("%0.2f", win_opts.width / spec.columns)),
		height = tonumber(string.format("%0.2f", win_opts.height / spec.lines)),
	}
end

M.change_cwd = function()
	---@type string
	---@diagnostic disable-next-line: assign-type-mismatch
	local head = vim.fn.expand("%:p:h")
	local git_ancestor = vim.fs.root(head, ".git") or head
	local cwd = vim.fn.getcwd()

	if cwd ~= git_ancestor then
		cwd = git_ancestor
	end

	local ok, _ = pcall(vim.fn.execute, "lcd " .. cwd, true)

	if ok then
		local formatted, home = cwd, os.getenv("HOME")
		if home then
			formatted = string.gsub(cwd, home, "~")
		end

		vim.notify("Set the current working directory to " .. formatted)
	else
		vim.notify("Failed to set the current working directory", vim.log.levels.WARN)
	end
end

return M
