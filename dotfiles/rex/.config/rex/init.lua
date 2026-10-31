local TERMINAL = "com.superlogical.terminal"
local SHELL = "com.superlogical.terminal.shell"
local HOME = os.getenv("HOME")

-- Whether the focused pane is running tmux in the foreground
local function in_tmux(ctx)
	local p = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
	local fg = p and p.foreground
	return fg ~= nil and (fg.name == "tmux" or fg.argv0 == "tmux")
end

-- The floating layer holding a block labelled `label`, if any
local function find_popup(label)
	local view, err = rex.session.view({})
	if err ~= nil then
		error(err, 0)
	end
	for _, window in ipairs(view.windows or {}) do
		for _, layer in ipairs(window.layers or {}) do
			if layer.kind == "floating" then
				for _, block in ipairs(layer.blocks or {}) do
					if block.label == label then
						return layer.layer_id
					end
				end
			end
		end
	end
end

-- Toggle a command in a centred floating layer, like `tmux popup -E`.
-- `label` identifies the popup, so a second trigger closes it instead.
local function popup(ctx, label, command, w, h)
	local existing = find_popup(label)
	if existing ~= nil then
		local _, err = rex.session.close_layer({ layer_id = existing })
		if err ~= nil then
			error(err, 0)
		end
		return
	end

	local _, err = rex.session.new_layer({
		bounds = { (1 - w) / 2, (1 - h) / 2, w, h },
		focus = true,
		layout = rex.layout.block({
			flavor = SHELL,
			label = label,
			options = { command = command, cwd = HOME },
		}),
	})
	if err ~= nil then
		error(err, 0)
	end
end

-- Ctrl+B is a tmux-style prefix outside tmux. Inside tmux it goes straight
-- through, so tmux keeps its own prefix.
rex.action({
	name = "prefix",
	title = "Ctrl-B Prefix",
	run = function(ctx)
		if in_tmux(ctx) then
			rex.block.call(TERMINAL, "write", { block_id = ctx.block_id, data = "\2" })
		else
			rex.client.queue("client.mode.enter", { name = "prefix", once = true })
		end
	end,
})

rex.action({
	name = "switchy",
	title = "Switch Session…",
	run = function(ctx)
		popup(ctx, "switchy", { HOME .. "/.local/bin/rex-switchy" }, 0.6, 0.5)
	end,
})

rex.mode("prefix", { exclusive = true })
rex.bind("ctrl+b", "prefix")
rex.bind("prefix/ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("prefix/p", "switchy")
