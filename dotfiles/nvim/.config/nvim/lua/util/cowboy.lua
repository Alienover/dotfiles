--- "Hold it Cowboy!" -- nudge when `hjkl` is repeated instead of reaching for a
--- real motion.
---
--- Registered as `mini.keymap` combos: `COUNT` presses of the same key, each
--- within `DELAY` of the previous one. This replaces a per-keystroke `expr`
--- mapping on every `hjkl`, at the cost of one behaviour change -- a combo
--- action runs *after* the key has been handled, so this only notifies where
--- the previous implementation also swallowed the movement.

local M = {}

local KEYS = { "h", "j", "k", "l" }
local COUNT = 10
-- INFO: matches the reset window of the previous timer-based implementation
local DELAY = 2000

---@param key string
local function notify(key)
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
		timeout = 1000,
	})
end

--- Register the combos. Called from the `mini.keymap` spec, so the discipline
--- follows that plugin being enabled.
function M.setup()
	local map_combo = require("mini.keymap").map_combo

	for _, key in ipairs(KEYS) do
		map_combo({ "n", "x" }, string.rep(key, COUNT), function()
			notify(key)
		end, { delay = DELAY })
	end

	vim.api.nvim_create_user_command("CowboyToggle", function()
		vim.g.cowboy_enabled = not vim.g.cowboy_enabled
	end, { desc = "Toggle the Cowboy discipline" })
end

return M
