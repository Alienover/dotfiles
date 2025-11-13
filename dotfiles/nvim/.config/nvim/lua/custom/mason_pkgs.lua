-- Mason enabled packages manager
local M = {
	data_path = vim.fn.stdpath("data") .. "/mason_enabled_pkgs",

	---Read enabled packages from file synchronously
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

		local enabled_pkgs = {}
		for line in data:gmatch("[^\r\n]+") do
			if line ~= "" then
				table.insert(enabled_pkgs, line)
			end
		end

		return enabled_pkgs
	end,

	---Write enabled packages to file asynchronously
	---@param enabled_pkgs string[]
	write = function(self, enabled_pkgs)
		local content = vim.deepcopy(enabled_pkgs)
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

	---Toggle a package in the enabled list
	---@param pkg_name string
	---@return boolean is_enabled
	toggle = function(self, pkg_name)
		local enabled_pkgs = self:read()

		local found = false
		local idx = nil
		for i, pkg in ipairs(enabled_pkgs) do
			if pkg == pkg_name then
				found = true
				idx = i
				break
			end
		end

		local is_enabled = not found
		if is_enabled then
			table.insert(enabled_pkgs, pkg_name)
		else
			table.remove(enabled_pkgs, idx)
		end

		self:write(enabled_pkgs)
		return is_enabled
	end,
}

return M
