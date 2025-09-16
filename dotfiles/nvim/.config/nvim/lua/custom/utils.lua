local window_sizing = require("custom.constants").window_sizing

local M = {}

---@alias KeymapMode string | string[]
---@alias KeymapLHS string
---@alias KeymapRHS string | fun(): nil
---@alias KeymapOPTs string|table|nil
---
---@param keymaps {[1]: KeymapMode, [2]: KeymapLHS, [3]: KeymapRHS, [4]: KeymapOPTs}[]
M.create_keymaps = function(keymaps)
	for _, keymap in ipairs(keymaps) do
		local modes, lhs, rhs, opts = unpack(keymap)

		M.map(modes, lhs, rhs, opts)
	end
end

---@alias CommandOPTName 'desc' | string
---@param commands {[1]: string, [2]: ( fun(): nil ), [3]: table<CommandOPTName, any>|nil}[]
M.create_commands = function(commands)
	for _, command in ipairs(commands) do
		local name, handler, opts = unpack(command)

		vim.api.nvim_create_user_command(
			name,
			handler,
			vim.tbl_extend("force", {
				desc = "User Command: " .. name,
			}, opts or {})
		)
	end
end

---@param expr string
M.expand = function(expr)
	---@diagnostic disable-next-line: param-type-mismatch
	local resp = vim.fn.expand(expr, false, false)
	if type(resp) == "table" then
		return resp[1]
	else
		return resp
	end
end

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

--- Setup vim options by given list
---@param options table
M.setup_options = function(options)
	for k, v in pairs(options) do
		vim.opt[k] = v
	end
end

--- Setup vim global variables
---@param global table
M.setup_global = function(global)
	for k, v in pairs(global) do
		vim.g[k] = v
	end
end

--- Setup custom filetyps
---@param filetypes vim.filetype.add.filetypes
M.setup_filetypes = function(filetypes)
	if vim.filetype then
		vim.filetype.add(filetypes)
	end
end

---@param module_name string
M.LazyRequire = function(module_name)
	return setmetatable({
		__module_name = module_name,
		__module = false,
	}, {
		__index = function(ctx, key)
			if not ctx.__module then
				local status_ok, module = pcall(require, ctx.__module_name)
				if not status_ok then
					vim.notify(string.format("Failed to load module: %s", ctx.__module_name), vim.log.levels.ERROR)
					return nil
				end

				ctx.__module = module
			end

			return ctx.__module[key]
		end,
	})
end

---
---@param name string
---@param mock_fun  fun(): table
M.MockPackage = function(name, mock_fun)
	package.preload[name] = function()
		local mock_pkg = mock_fun()

		if package.loaded[name] == nil then
			package.preload[name] = function()
				return mock_pkg
			end
		else
			package.loaded[name] = mock_pkg
		end

		return mock_pkg
	end
end

return M
