local TERMINAL = "com.superlogical.terminal"
local SHELL = "com.superlogical.terminal.shell"
local HOME = os.getenv("HOME")

-- Whether the focused pane is running tmux in the foreground
local function in_tmux(ctx)
	local p = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
	local fg = p and p.foreground
	return fg ~= nil and (fg.name == "tmux" or fg.argv0 == "tmux")
end

-- Run a command in a centred floating layer, like `tmux popup -E`
local function popup(ctx, command, w, h)
	local _, err = rex.session.new_layer({
		bounds = { (1 - w) / 2, (1 - h) / 2, w, h },
		focus = true,
		layout = rex.layout.block({
			flavor = SHELL,
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
		popup(ctx, { HOME .. "/.local/bin/rex-switchy" }, 0.6, 0.5)
	end,
})

rex.mode("prefix", { exclusive = true })
rex.bind("ctrl+b", "prefix")
rex.bind("prefix/ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("prefix/p", "switchy")
