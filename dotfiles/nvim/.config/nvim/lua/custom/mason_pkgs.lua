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

	---Toggle a package in the disabled list
	---@param pkg_name string
	---@return boolean is_disabled
	toggle = function(self, pkg_name)
		local disabled_pkgs = self:read()

		local found = false
		local idx = nil
		for i, pkg in ipairs(disabled_pkgs) do
			if pkg == pkg_name then
				found = true
				idx = i
				break
			end
		end

		local is_disabled = not found
		if is_disabled then
			table.insert(disabled_pkgs, pkg_name)
		else
			table.remove(disabled_pkgs, idx)
		end

		self:write(disabled_pkgs)
		return is_disabled
	end,
}

return M
