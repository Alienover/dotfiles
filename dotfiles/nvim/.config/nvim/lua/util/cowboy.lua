--- "Hold it Cowboy!" -- nudge when `hjkl` is repeated instead of reaching for a
--- real motion.
---
--- Registered as `mini.keymap` combos: `COUNT` presses of the same key, each
--- within `DELAY` of the previous one.
---
--- A combo action runs *after* the key has been handled, so the press that
--- trips the counter cannot be swallowed. Everything after it can: the action
--- shadows the key with a buffer-local `<Nop>` for `BLOCK` milliseconds.
--- Buffer-local mappings win over global ones, so the real `hjkl` mappings are
--- never touched -- deleting the temporary one restores them.

local M = {}

local KEYS = { "h", "j", "k", "l" }
local MODES = { "n", "x" }

local COUNT = 10
-- INFO: matches the reset window of the previous timer-based implementation
local DELAY = 2000
-- INFO: how long the key stays inert once the nudge fires
local BLOCK = 2000

---@type table<string, boolean>
local blocked = {}

---@param key string
---@param buf integer
local function unblock(key, buf)
	blocked[key] = nil

	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	for _, mode in ipairs(MODES) do
		pcall(vim.keymap.del, mode, key, { buffer = buf })
	end
end

--- Shadow `key` with a no-op until `BLOCK` has passed.
---@param key string
local function block(key)
	if blocked[key] then
		return
	end

	blocked[key] = true

	local buf = vim.api.nvim_get_current_buf()

	vim.keymap.set(MODES, key, "<Nop>", {
		buffer = buf,
		desc = "Hold it Cowboy! (" .. key .. " on a break)",
	})

	vim.defer_fn(function()
		unblock(key, buf)
	end, BLOCK)
end

---@param key string
local function nudge(key)
	if
		not vim.g.cowboy_enabled -- Global switch
		or vim.bo.buftype ~= "" -- Not a normal buffer
		or vim.api.nvim_buf_get_name(0) == "" -- Has no filename
	then
		return
	end

	vim.notify(("Hold it Cowboy! %d× %s"):format(COUNT, key), vim.log.levels.WARN, {
		icon = "🤯",
		id = "cowboy",
		timeout = BLOCK,
	})

	block(key)
end

--- Register the combos. Called from the `mini.keymap` spec, so the discipline
--- follows that plugin being enabled.
function M.setup()
	local map_combo = require("mini.keymap").map_combo

	for _, key in ipairs(KEYS) do
		map_combo(MODES, string.rep(key, COUNT), function()
			nudge(key)
		end, { delay = DELAY })
	end

	vim.api.nvim_create_user_command("CowboyToggle", function()
		vim.g.cowboy_enabled = not vim.g.cowboy_enabled

		-- INFO: do not leave a key inert when switching the discipline off
		if not vim.g.cowboy_enabled then
			for key in pairs(blocked) do
				unblock(key, vim.api.nvim_get_current_buf())
			end
		end
	end, { desc = "Toggle the Cowboy discipline" })
end

return M
