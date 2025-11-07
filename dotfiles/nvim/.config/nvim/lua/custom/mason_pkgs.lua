-- Mason enabled packages manager
local M = {
	data_path = vim.fn.stdpath("data") .. "/mason_enabled_pkgs",

	---Read enabled packages from file asynchronously
	---@param callback function(string[])
	read = function(self, callback)
		vim.uv.fs_open(self.data_path, "r", 438, function(err, fd)
			if err or not fd then
				callback({})
				return
			end
			vim.uv.fs_fstat(fd, function(stat_err, stat)
				if stat_err or not stat then
					vim.uv.fs_close(fd)
					callback({})
					return
				end
				vim.uv.fs_read(fd, stat.size, 0, function(read_err, data)
					vim.uv.fs_close(fd)
					if read_err or not data then
						callback({})
						return
					end
					local enabled_pkgs = {}
					for line in data:gmatch("[^\r\n]+") do
						if line ~= "" then
							table.insert(enabled_pkgs, line)
						end
					end
					callback(enabled_pkgs)
				end)
			end)
		end)
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
	---@param callback function(boolean)
	toggle = function(self, pkg_name, callback)
		self:read(function(enabled_pkgs)
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
			callback(is_enabled)
		end)
	end,
}

return M
