-- Seamless Ctrl+h/j/k/l between nvim splits and Rex or Herdr panes.
-- Moves between nvim windows first; at the edge it asks the app to focus the
-- neighbouring pane. The app passes the key through to nvim (Rex:
-- dotfiles/rex/.config/rex/plugins/navigate.lua, Herdr:
-- dotfiles/herdr-app/.config/herdr-app/mods/nav-*).
local M = {}

local directions = { h = "left", j = "down", k = "up", l = "right" }

-- How to focus the pane in a direction, for the app nvim runs in
local backends = {
	rex = function(direction)
		return { "rex", "focus", "-s", vim.env.REX_SESSION, direction }
	end,
	herdr = function(direction)
		return { "herdr-app", "do", "pane.go", "--direction", direction }
	end,
}

-- "rex", "herdr" or nil. Not inside tmux, which has its own navigator.
-- Herdr in a devpod has no herdr-app, so nvim there only moves between its
-- own splits.
local function backend()
	if vim.env.TMUX ~= nil then
		return nil
	end
	if vim.env.REX_SESSION ~= nil and vim.fn.executable("rex") == 1 then
		return "rex"
	end
	if vim.env.HC_TERMINAL_ID ~= nil and vim.fn.executable("herdr-app") == 1 then
		return "herdr"
	end
	return nil
end

function M.enabled()
	return backend() ~= nil
end

---@param key "h"|"j"|"k"|"l"
function M.navigate(key)
	local win = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(key)
	if vim.api.nvim_get_current_win() ~= win then
		return
	end
	local name = backend()
	if name == nil then
		return
	end
	vim.system(backends[name](directions[key]), { text = true }, function(r)
		if r.code ~= 0 then
			vim.schedule(function()
				vim.notify(name .. " focus failed: " .. vim.trim(r.stderr or ""), vim.log.levels.WARN)
			end)
		end
	end)
end

return M
