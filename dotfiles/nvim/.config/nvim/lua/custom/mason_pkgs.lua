-- Mason disabled packages manager
local M = {
	data_path = vim.fn.stdpath("data") .. "/mason_disabled_pkgs",

	---Read disabled packages from file synchronously
	---@return string[]
	read = function(self)
		local fd, err = vim.uv.fs_open(self.data_path, "r", 438)
		if err or not fd then
			return {}
		end

		local stat, stat_err = vim.uv.fs_fstat(fd)
		if stat_err or not stat then
			vim.uv.fs_close(fd)
			return {}
		end

		local data, read_err = vim.uv.fs_read(fd, stat.size, 0)
		vim.uv.fs_close(fd)

		if read_err or not data then
			return {}
		end

		local disabled_pkgs = {}
		for line in data:gmatch("[^\r\n]+") do
			if line ~= "" then
				table.insert(disabled_pkgs, line)
			end
		end

		return disabled_pkgs
	end,

	---Write disabled packages to file asynchronously
	---@param disabled_pkgs string[]
	write = function(self, disabled_pkgs)
		local content = vim.deepcopy(disabled_pkgs)
		table.sort(content)
		vim.uv.fs_open(self.data_path, "w", 438, function(err, fd)
			if err or not fd then
				return
			end
			vim.uv.fs_write(fd, table.concat(content, "\n") .. "\n", -1, function()
				vim.uv.fs_close(fd)
			end)
		end)
	end,

	---Toggle package(s) in the disabled list
	---@param pkg_name string|string[] Package name or list of package names
	---@return boolean|table<string, boolean> is_disabled (boolean for single, table for batch)
	toggle = function(self, pkg_name)
		-- Detect input type and normalize to list
		local is_single = type(pkg_name) == "string"
		---@type string[]
		---@diagnostic disable-next-line: assign-type-mismatch
		local pkg_list = is_single and { pkg_name } or pkg_name

		-- Handle empty table input
		if not is_single and #pkg_list == 0 then
			return {}
		end

		-- Read disabled packages once
		local disabled_pkgs = self:read()

		-- Convert to set for O(1) operations
		local disabled_set = {}
		for _, pkg in ipairs(disabled_pkgs) do
			disabled_set[pkg] = true
		end

		-- Toggle each package in the set
		local results = {}
		for _, pkg in ipairs(pkg_list) do
			local is_disabled = not disabled_set[pkg]
			if is_disabled then
				disabled_set[pkg] = true
			else
				disabled_set[pkg] = nil
			end
			results[pkg] = is_disabled
		end

		-- Convert set back to list and write once
		local new_disabled_pkgs = {}
		for pkg, _ in pairs(disabled_set) do
			table.insert(new_disabled_pkgs, pkg)
		end
		self:write(new_disabled_pkgs)

		-- Return based on input type
		return is_single and results[pkg_name] or results
	end,
}

return M
