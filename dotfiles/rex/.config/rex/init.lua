local TERMINAL = "com.superlogical.terminal"
local BIN = os.getenv("HOME") .. "/.local/bin"

-- Whether the focused pane is running tmux in the foreground
local function in_tmux(ctx)
	local p = rex.block.call(TERMINAL, "process", { block_id = ctx.block_id })
	local fg = p and p.foreground
	return fg ~= nil and (fg.name == "tmux" or fg.argv0 == "tmux")
end

-- Run a script with the session and block the action applies to
local function run(ctx, argv)
	local r, err = rex.exec(argv, {
		env = { REX_SESSION = ctx.session_id, REX_BLOCK = ctx.block_id },
		timeout = 10,
	})
	if r == nil then
		error(err, 0)
	end
	if not r.ok then
		error(r.stderr, 0)
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
		run(ctx, { BIN .. "/rex-popup", "-t", "-l", "switchy", "-w", "100", "-h", "25", "rex-switchy" })
	end,
})

-- Go to the Nth tab of the current session. client.tab.goto counts tabs
-- across every session, and the app keeps its own selected tab, so ask it
-- to show the window rather than focusing it on the server.
rex.action({
	name = "tab_goto",
	title = "Go to Tab in Session",
	args = { index = "integer" },
	run = function(ctx, args)
		local view, err = rex.session.view({})
		if err ~= nil then
			error(err, 0)
		end
		local window = (view.windows or {})[args.index]
		if window == nil then
			return
		end
		rex.client.queue("session.select", { session_id = ctx.session_id, window_id = window.window_id })
	end,
})

rex.mode("prefix", { exclusive = true })
rex.bind("ctrl+b", "prefix")
rex.bind("prefix/ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("prefix/p", "switchy")

-- tmux defaults
rex.bind("prefix/shift+5", "pane.split", { direction = "right" }) -- %
rex.bind("prefix/shift+'", "pane.split", { direction = "down" }) -- "
rex.bind("prefix/c", "client.tab.new")
for i = 1, 9 do
	rex.bind("prefix/" .. i, "tab_goto", { index = i })
end
