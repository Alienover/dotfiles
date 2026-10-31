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

-- The previously active tab per session, for `prefix l`. Rex doesn't track
-- it, so tab switches made through the prefix record it here.
local last_window = {}

local function active_window()
	local view, err = rex.session.view({})
	if err ~= nil then
		error(err, 0)
	end
	return view.active_window_id
end

local function remember(ctx)
	last_window[ctx.session_id] = active_window()
end

rex.action({
	name = "tab_new",
	title = "New Tab (remember last)",
	run = function(ctx)
		remember(ctx)
		rex.client.queue("client.tab.new")
	end,
})

rex.action({
	name = "tab_goto",
	title = "Go to Tab (remember last)",
	args = { index = "integer" },
	run = function(ctx, args)
		remember(ctx)
		rex.client.queue("client.tab.goto", { index = args.index })
	end,
})

rex.action({
	name = "tab_last",
	title = "Last Tab",
	run = function(ctx)
		local target = last_window[ctx.session_id]
		local current = active_window()
		if target == nil or target == current then
			return
		end
		local _, err = rex.session.focus_window({ window_id = target })
		if err ~= nil then
			last_window[ctx.session_id] = nil
			return
		end
		last_window[ctx.session_id] = current
	end,
})

rex.mode("prefix", { exclusive = true })
rex.bind("ctrl+b", "prefix")
rex.bind("prefix/ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("prefix/p", "switchy")

-- tmux defaults
rex.bind("prefix/shift+5", "pane.split", { direction = "right" }) -- %
rex.bind("prefix/shift+'", "pane.split", { direction = "down" }) -- "
rex.bind("prefix/c", "tab_new")
rex.bind("prefix/l", "tab_last")
for i = 1, 9 do
	rex.bind("prefix/" .. i, "tab_goto", { index = i })
end
