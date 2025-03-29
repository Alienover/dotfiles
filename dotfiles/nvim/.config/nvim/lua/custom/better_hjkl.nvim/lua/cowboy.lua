---@class CowboyContext
---@field count integer
---@field timer any

--- @class CowboyState
--- @field enabled boolean
--- @field notify table?
--- @field config DisciplineConfig
--- @field registered table<string, CowboyContext>
local M = {
	enabled = false,
	registered = {},
}

--- check whether the inpu is violating the discipline rules
--- @param key string
--- @return boolean
function M:check(key)
	-- INFO: bypass when it's not enabled
	if not self.enabled then
		return true
	end

	--INFO: bypass when the filetype is excluded
	local excluded_fts = self.config.excluded_filetypes
	if vim.tbl_contains(excluded_fts, vim.bo.filetype) then
		return true
	end

	--INFO: bypass when the key is un-registered
	if self.registered[key] == nil then
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

function M:toggle()
	self.enabled = not self.enabled
end

--- register the key to follow the discipline rules
--- @param key string
function M:register(key)
	--- @type CowboyContext
	local ctx = {
		count = 0,
		timer = assert(vim.uv.new_timer()),
	}

	self.registered[key] = ctx
end

--- initialize the cowboy
--- @param ctx HJKL_Config
function M:new(ctx)
	local state = vim.tbl_extend("force", {}, M)
	setmetatable(state, { __index = self })

	if ctx.discipline.enabled and #ctx.discipline.keys > 0 then
		state.enabled = true
	end

	state.config = ctx.discipline

	for _, key in ipairs(ctx.discipline.keys) do
		state:register(key)
	end

	--- @type CowboyState
	return state
end

return M
