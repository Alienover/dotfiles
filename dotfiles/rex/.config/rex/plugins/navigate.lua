-- Ctrl+h/j/k/l moves between panes, like vim-tmux-navigator. When one of
-- `apps` is in the foreground the key goes through to it, so it can move
-- within its own splits first (nvim calls `rex focus` at the edge, tmux uses
-- vim-tmux-navigator).
local M = {}

local TERMINAL = "com.superlogical.terminal"

local defaults = {
	apps = { "nvim", "vim", "tmux" },
	keys = { h = "left", j = "down", k = "up", l = "right" },
	modifier = "ctrl",
}

local function contains(list, value)
	for _, v in ipairs(list) do
		if v == value then
			return true
		end
	end
	return false
end

local function passthrough(ctx, apps)
	local p = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
	local fg = p and p.foreground
	return fg ~= nil and (contains(apps, fg.name) or contains(apps, fg.argv0))
end

function M.setup(opts)
	opts = opts or {}
	local apps = opts.apps or defaults.apps
	local keys = opts.keys or defaults.keys
	local modifier = opts.modifier or defaults.modifier

	rex.action({
		name = "navigate",
		title = "Navigate Pane",
		args = { direction = "string", key = "string" },
		run = function(ctx, args)
			if passthrough(ctx, apps) then
				rex.client.queue("pane.send_key", { key = args.key })
			else
				rex.client.queue("pane.focus", { direction = args.direction })
			end
		end,
	})

	for key, direction in pairs(keys) do
		local chord = modifier .. "+" .. key
		rex.bind(chord, "navigate", { direction = direction, key = chord })
	end
end

return M
