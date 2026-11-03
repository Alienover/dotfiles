-- Seamless Ctrl+h/j/k/l between nvim splits and Rex or Herdr panes.
-- Moves between nvim windows first; at the edge the app focuses the
-- neighbouring pane. The app passes the key through to nvim when nvim is in
-- the foreground (Rex: dotfiles/rex/.config/rex/plugins/navigate.lua, Herdr:
-- dotfiles/herdr-app/.config/herdr-app/mods/nav).
--
-- Herdr: every press is answered with a label on nvim's own terminal,
-- `nav.reply=<id>:<moved|edge>:<direction>`, and the nav mod moves the Herdr
-- pane on `edge`. `hc` is on every machine Herdr reaches, `herdr-app` only on
-- this one, so this also works in remote spaces. (After splits-nav's nvim
-- half, TaterDoge/herdr-mods, which answers over a local TCP port instead.)
local M = {}

local directions = { h = "left", j = "down", k = "up", l = "right" }

-- Neovim's default float zindex: below it a float is "embedded", laid out like
-- a sidebar beside normal splits (snacks explorer, ...).
local FLOAT_ZINDEX = 50

local function hc_path()
	local path = vim.fn.exepath("hc")
	if path ~= "" then
		return path
	end
	path = vim.fn.expand("~/.local/bin/hc")
	return vim.fn.executable(path) == 1 and path or nil
end

-- "rex", "herdr" or nil. Not inside tmux, which has its own navigator.
local function backend()
	if vim.env.TMUX ~= nil then
		return nil
	end
	if vim.env.REX_SESSION ~= nil and vim.fn.executable("rex") == 1 then
		return "rex"
	end
	if vim.env.HC_TERMINAL_ID ~= nil and hc_path() ~= nil then
		return "herdr"
	end
	return nil
end

-- Inside Rex or Herdr the app sends Ctrl+h/j/k/l to nvim, so map them even
-- when nvim can't hand off at its edge itself.
function M.enabled()
	return vim.env.TMUX == nil and (vim.env.REX_SESSION ~= nil or vim.env.HC_TERMINAL_ID ~= nil)
end

local function is_float(win)
	return vim.api.nvim_win_get_config(win).relative ~= ""
end

local function is_embedded(win)
	local cfg = vim.api.nvim_win_get_config(win)
	return cfg.relative ~= "" and cfg.zindex ~= nil and cfg.zindex < FLOAT_ZINDEX
end

-- The normal window an embedded float is laid out in, following
-- window-relative parents within the tabpage; nil when the chain is odd.
local function embedded_parent(win)
	local tab = vim.api.nvim_win_get_tabpage(win)
	local seen = {}
	while not seen[win] do
		seen[win] = true
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.relative == "" then
			return win
		end
		local parent = cfg.win
		if
			cfg.relative ~= "win"
			or type(parent) ~= "number"
			or not vim.api.nvim_win_is_valid(parent)
			or vim.api.nvim_win_get_tabpage(parent) ~= tab
		then
			return nil
		end
		win = parent
	end
	return nil
end

-- The window `wincmd {key}` would reach from `ref` (floats excluded), or nil.
local function neighbor(ref, key)
	local target = vim.api.nvim_win_call(ref, function()
		local here, there = vim.fn.winnr(), vim.fn.winnr(key)
		return there ~= here and vim.fn.win_getid(there) or nil
	end)
	return target ~= ref and target or nil
end

-- Move to the nvim window in that direction: "moved" or "edge" (nothing that
-- way, so the app should move its pane).
---@param key "h"|"j"|"k"|"l"
---@return "moved"|"edge"
local function move(key)
	-- Window commands raise E11 in the command-line window
	if vim.fn.getcmdwintype() ~= "" then
		return "edge"
	end
	local from = vim.api.nvim_get_current_win()
	local ref = from
	if is_float(from) then
		if not is_embedded(from) then
			return "edge"
		end
		ref = embedded_parent(from)
		if ref == nil then
			return "edge"
		end
	end
	local target = neighbor(ref, key)
	if target == nil then
		return "edge"
	end
	-- An autocmd may send focus elsewhere (snacks' explorer to its picker):
	-- it moved as long as focus left where it was
	pcall(vim.api.nvim_set_current_win, target)
	return vim.api.nvim_get_current_win() ~= from and "moved" or "edge"
end

local function warn_on_failure(name)
	return function(r)
		if r.code ~= 0 then
			vim.schedule(function()
				vim.notify(name .. " navigation failed: " .. vim.trim(r.stderr or ""), vim.log.levels.WARN)
			end)
		end
	end
end

---@param key "h"|"j"|"k"|"l"
function M.navigate(key)
	local result = move(key)
	local name = backend()
	if name == "herdr" then
		-- An id unique to this press, so the mod sees every reply as a change
		local reply = ("nav.reply=%d:%s:%s"):format(vim.uv.hrtime(), result, directions[key])
		vim.system({ hc_path(), "label", vim.env.HC_TERMINAL_ID, reply }, { text = true }, warn_on_failure(name))
	elseif name == "rex" and result == "edge" then
		vim.system(
			{ "rex", "focus", "-s", vim.env.REX_SESSION, directions[key] },
			{ text = true },
			warn_on_failure(name)
		)
	end
end

return M
