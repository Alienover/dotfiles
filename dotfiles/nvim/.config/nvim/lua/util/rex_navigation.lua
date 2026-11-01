-- Seamless Ctrl+h/j/k/l between nvim splits and Rex panes.
-- Moves between nvim windows first; at the edge it asks Rex to focus the
-- neighbouring pane. The Rex side passes the key through to nvim (see
-- dotfiles/rex/.config/rex/init.lua, action `navigate`).
local M = {}

local directions = { h = "left", j = "down", k = "up", l = "right" }

-- Only inside Rex and not inside tmux (tmux has its own navigator)
function M.enabled()
	return vim.env.REX_SESSION ~= nil and vim.env.TMUX == nil and vim.fn.executable("rex") == 1
end

---@param key "h"|"j"|"k"|"l"
function M.navigate(key)
	local win = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(key)
	if vim.api.nvim_get_current_win() ~= win then
		return
	end
	vim.system({ "rex", "focus", "-s", vim.env.REX_SESSION, directions[key] }, { text = true }, function(r)
		if r.code ~= 0 then
			vim.schedule(function()
				vim.notify("rex focus failed: " .. vim.trim(r.stderr or ""), vim.log.levels.WARN)
			end)
		end
	end)
end

return M
