-- Seamless Ctrl+h/j/k/l between nvim splits and Rex or Herdr panes.
-- Moves between nvim windows first; at the edge it asks the app to focus the
-- neighbouring pane. The app passes the key through to nvim (Rex:
-- dotfiles/rex/.config/rex/plugins/navigate.lua, Herdr:
-- dotfiles/herdr-app/.config/herdr-app/mods/nav-*).
--
-- In Herdr, nvim also keeps a label on its terminal, `mux.nav=nvim:<edges>`
-- (see M.setup), so the nav mods know nvim is there without asking ps, and at
-- an edge move Herdr's focus themselves instead of forwarding the key: a
-- forwarded key costs ~65 ms, a direct move ~20 ms. This also covers nvim in a
-- devpod, which has `hc` but no `herdr-app` to hand off with.
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

-- Inside Rex or Herdr the app sends Ctrl+h/j/k/l to nvim, so map them even
-- when nvim can't hand off at its edge itself.
function M.enabled()
	return vim.env.TMUX == nil and (vim.env.REX_SESSION ~= nil or vim.env.HC_TERMINAL_ID ~= nil)
end

-- Herdr label ---------------------------------------------------------------

local LABEL = "mux.nav"
local sent = nil -- the value Herdr has
local wanted = nil -- the value to send next
local sending = false
local leaving = false

-- Sets the label to `value` ("" removes it). One `hc label` at a time, and
-- only when the value changes, so quick window changes collapse into one.
local function send(value)
	wanted = value
	if leaving or sending or wanted == sent then
		return
	end
	sending = true
	local v = wanted
	vim.system({ "hc", "label", vim.env.HC_TERMINAL_ID, LABEL .. "=" .. v }, {}, function()
		vim.schedule(function()
			sending = false
			sent = v -- also on failure, so a broken hc isn't retried forever
			if wanted ~= sent then
				send(wanted)
			end
		end)
	end)
end

-- The edges ("hjkl" letters) the current window touches. None outside normal
-- mode (Ctrl+h is backspace in insert and cmdline mode) or in a floating
-- window (pickers like Telescope use Ctrl+j/k), so Herdr forwards the key.
local function edges()
	if vim.api.nvim_get_mode().mode ~= "n" or vim.api.nvim_win_get_config(0).relative ~= "" then
		return ""
	end
	local cur = vim.fn.winnr()
	local found = ""
	for _, key in ipairs({ "h", "j", "k", "l" }) do
		if vim.fn.winnr(key) == cur then
			found = found .. key
		end
	end
	return found
end

local function announce()
	send("nvim:" .. edges())
end

-- Keeps the label up to date (Herdr only; Rex inspects the process itself).
function M.setup()
	if vim.env.TMUX ~= nil or vim.env.HC_TERMINAL_ID == nil or vim.fn.executable("hc") == 0 then
		return
	end
	local group = vim.api.nvim_create_augroup("mux_navigation", { clear = true })
	vim.api.nvim_create_autocmd(
		{ "VimEnter", "VimResume", "WinEnter", "WinClosed", "WinResized", "VimResized", "TabEnter", "ModeChanged" },
		{
			group = group,
			-- After the event, once the window layout has settled
			callback = function()
				vim.schedule(announce)
			end,
		}
	)
	vim.api.nvim_create_autocmd("VimSuspend", {
		group = group,
		callback = function()
			send("")
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			-- No more updates, let one in flight land first, then remove the
			-- label and wait, or nvim exits before it is gone (and lf, say,
			-- keeps a stale label)
			leaving = true
			vim.wait(300, function()
				return not sending
			end, 10)
			vim.system({ "hc", "label", vim.env.HC_TERMINAL_ID, LABEL .. "=" }):wait(500)
		end,
	})
	if vim.v.vim_did_enter == 1 then
		announce()
	end
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
