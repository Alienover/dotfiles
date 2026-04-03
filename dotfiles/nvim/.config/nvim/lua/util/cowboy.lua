---@class CowboyContext
---@field count integer
---@field timer any

local M = {
	registered = {},
}

M.registered = setmetatable({}, {
	__index = function(tbl, key)
		tbl[key] = {
			count = 0,
			timer = assert(vim.uv.new_timer()),
		}

		return tbl[key]
	end,
})

--- check whether the inpu is violating the discipline rules
--- @param key string
--- @return boolean
function M:check(key)
	-- INFO: bypass when it's not enabled
	if
		not vim.g.cowboy_enabled -- Global switch
		or vim.bo[0].buftype ~= "" -- Not a normal buffer
		or vim.api.nvim_buf_get_name(0) == "" -- Has not filename
	then
		return true
	end

	---@type integer
	local count = self.registered[key].count
	local timer = self.registered[key].timer

	-- INFO: reset counter when doing hjkl with number prefix
	if vim.v.count > 0 then
		self.registered[key].count = 0

		timer:stop()

		return true
	end

	if count < 10 then
		-- INFO: increase counter and set timer to reset it after 2 seconds
		self.registered[key].count = count + 1

		timer:stop()
		timer:start(2000, 0, function()
			self.registered[key].count = 0

			timer:stop()
		end)

		return true
	else
		-- INFO: show notice
		local ok, _ = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
			icon = "🤯",
			id = "cowboy",
			keep = function()
				return self.registered[key].count >= 10
			end,
		})

		return not ok
	end
end

vim.api.nvim_create_user_command("CowboyToggle", function()
	vim.g.cowboy_enabled = not vim.g.cowboy_enabled
end, { desc = "Toggle the Cowboy discipline" })

return M
