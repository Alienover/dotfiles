-- Seamless Ctrl+h/j/k/l between nvim splits and Rex or Herdr panes.
-- Moves between nvim windows first; at the edge the app focuses the
-- neighbouring pane (Rex: dotfiles/rex/.config/rex/plugins/navigate.lua,
-- Herdr: dotfiles/herdr-app/.config/herdr-app/mods/nav).
--
-- Herdr takes Ctrl+h/j/k/l itself, and for a local nvim its nav mod calls
-- M.herdr() over nvim's own RPC socket (`nvim --server ... --remote-expr`),
-- which answers "moved" or "edge"; on "edge" the mod moves the Herdr pane.
-- (Typing the key in with `hc keys` was slow: it waits until nobody has typed
-- for a moment.) So the mod can find the socket, nvim puts it on its terminal
-- as the label `nav.nvim`. After splits-nav's request/reply, TaterDoge/herdr-mods.
local M = {}

local directions = { h = "left", j = "down", k = "up", l = "right" }

-- Not inside tmux, which has its own navigator.
function M.enabled()
	return vim.env.TMUX == nil and (vim.env.REX_SESSION ~= nil or vim.env.HC_TERMINAL_ID ~= nil)
end

local function hc(...)
	if vim.env.HC_TERMINAL_ID == nil or vim.fn.executable("hc") == 0 then
		return
	end
	vim.system({ "hc", "label", vim.env.HC_TERMINAL_ID, ... })
end

-- Put this nvim's RPC socket on its terminal for the nav mod, and take it off
-- again on exit.
function M.advertise()
	if vim.env.TMUX ~= nil or vim.v.servername == "" then
		return
	end
	hc("nav.nvim=" .. vim.v.servername)
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			hc("nav.nvim=")
		end,
	})
end

-- Move to the nvim window in that direction: "moved", or "edge" when there's
-- none (or window commands aren't allowed here, as in the command-line window).
---@param key "h"|"j"|"k"|"l"
---@return "moved"|"edge"
function M.move(key)
	local win = vim.api.nvim_get_current_win()
	pcall(vim.cmd.wincmd, key)
	return vim.api.nvim_get_current_win() ~= win and "moved" or "edge"
end

-- Herdr's nav mod calls this over RPC. In insert, replace, command-line and
-- terminal mode the key keeps its usual meaning (Ctrl+h is backspace...).
---@param key "h"|"j"|"k"|"l"
---@return "moved"|"edge"|"passthrough"
function M.herdr(key)
	if vim.fn.mode():match("^[iRct]") then
		vim.api.nvim_feedkeys(vim.keycode("<C-" .. key .. ">"), "m", false)
		return "passthrough"
	end
	return M.move(key)
end

-- The key mapping: Rex sends the key to nvim, and nvim asks Rex to move at
-- its edge. In Herdr the key only arrives typed in (`hc keys`, when the mod
-- can't reach nvim's socket), and then just moves between nvim windows.
---@param key "h"|"j"|"k"|"l"
function M.navigate(key)
	if M.move(key) == "edge" and vim.env.REX_SESSION ~= nil and vim.env.TMUX == nil and vim.fn.executable("rex") == 1 then
		vim.system({ "rex", "focus", "-s", vim.env.REX_SESSION, directions[key] }, { text = true }, function(r)
			if r.code ~= 0 then
				vim.schedule(function()
					vim.notify("rex focus failed: " .. vim.trim(r.stderr or ""), vim.log.levels.WARN)
				end)
			end
		end)
	end
end

return M
