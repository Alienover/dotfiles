--- herdr-app backend for sidekick.nvim (`cli.mux.backend = "herdr"`).
---
--- Registered from the outside through `sidekick.cli.session.register()`, so
--- sidekick itself stays unforked. Uses two CLIs:
--- * `hc` (herdr-core) runs, lists, reads and attaches to terminals
--- * `herdr-app do` places a terminal in the window (split or tab)
---
--- Modes (`cli.mux.create`):
--- * terminal: a hidden core terminal (no herdr labels, so not in the app's
---   screens), shown in a Neovim terminal through `hc attach`
--- * split / window: a real herdr pane beside Neovim's, or a new tab
---
--- `hc send` always presses Enter and `hc keys` only knows named keys, so
--- text is sent through a short hidden `hc attach` at the terminal's own size
--- (no resize), as a bracketed paste, then detached with ctrl+\.
local Config = require("sidekick.config")
local Util = require("sidekick.util")

---@class sidekick.cli.muxer.Herdr: sidekick.cli.Session
---@field hc_terminal? string core terminal address (t7)
---@field just_started? boolean herdr just gave this new pane the keyboard
---@field _live? boolean
---@field _live_at? integer
local M = {}
M.__index = M

---@class sidekick.herdr.Opts
M.opts = {
	-- focus the agent's herdr pane where sidekick would focus its terminal
	-- window (create, toggle, show, select, send, focus). sidekick's own
	-- `focus = false` still keeps Neovim focused
	focus = true,
}

local PASTE_START, PASTE_END, DETACH = "\27[200~", "\27[201~", "\28"
local PUMP_DELAY = 100 -- ms between writes on the hidden attach (paste, then Enter)
local SH_CD = 'cd "$1" || exit 1; shift; exec "$@"'

--- The JSON a command printed; nil when it isn't JSON, nil and the message
--- when it's an `{ "error": ... }` reply.
---@param out? string
---@return table?, string? err
local function decode(out)
	local ok, ret = pcall(vim.json.decode, out or "")
	if not ok or type(ret) ~= "table" then
		return nil
	end
	if ret.error then
		local err = ret.error
		return nil, type(err) == "table" and (err.message or err.kind) or tostring(err)
	end
	return ret
end

--- Run a command that prints JSON (`hc ... --json`, `herdr-app do`).
---@param cmd string[]
---@param notify? boolean
---@return table?
local function run(cmd, notify)
	local result = vim.system(cmd, { text = true }):wait()
	local ret, err = decode(result.stdout)
	if ret and result.code == 0 then
		return ret
	end
	if notify then
		local stderr = vim.trim(result.stderr or "")
		err = err or (stderr ~= "" and stderr) or ("exit code " .. result.code)
		Util.error(("`%s` failed: %s"):format(table.concat(cmd, " "), err))
	end
end

--- `hc <command> --json <args...>`
---@param args string[]
local function hc_cmd(args)
	local cmd = { "hc", args[1], "--json" }
	return vim.list_extend(cmd, args, 2)
end

---@param args string[]
---@param notify? boolean
local function hc(args, notify)
	return run(hc_cmd(args), notify)
end

---@param name string
---@param args table
local function herdr_do(name, args)
	return run({ "herdr-app", "do", name, vim.json.encode(args) }, true)
end

--- The pane that shows Neovim's own terminal.
---@return string?
local function own_pane()
	local me = vim.env.HC_TERMINAL_ID
	local ls = me and run({ "herdr-app", "ls" }, true)
	if not ls then
		return
	end
	for _, space in ipairs(ls.spaces or {}) do
		for _, tab in ipairs(space.tabs or {}) do
			for _, t in ipairs(tab.terminals or {}) do
				if t.terminal == me then
					return t.pane
				end
			end
		end
	end
	Util.error("Neovim is not in a herdr pane, can't split")
end

--- `env` argv applying the tool's env (core terminals don't inherit ours).
---@return string[]
function M:argv()
	local ret = { "env" }
	for key, value in pairs(self.tool.env or {}) do
		if value == false then
			vim.list_extend(ret, { "-u", key })
		else
			ret[#ret + 1] = ("%s=%s"):format(key, tostring(value))
		end
	end
	return vim.list_extend(ret, self.tool.cmd)
end

---@param address string
function M:set_terminal(address)
	self.hc_terminal = address
	self.id = "hc " .. address
	self.mux_session = address
	self.started = true
	self._live, self._live_at = true, vim.uv.now()
end

function M:init()
	if not self.started then
		self.external = vim.env.HC_TERMINAL_ID ~= nil and Config.cli.mux.create ~= "terminal"
	end
	self.priority = self.external and 10 or 50
end

---@return sidekick.cli.terminal.Cmd?
function M:attach()
	if not self.external and self.hc_terminal then
		return { cmd = { "hc", "attach", self.hc_terminal } }
	end
end

---@return sidekick.cli.terminal.Cmd?
function M:start()
	if not self.external then
		-- no --keep: a killed agent must end the terminal, not leave a shell
		-- behind that still reads as running and gets the next paste
		local args = { "run", "--bg", "--no-parent", "--cwd", self.cwd }
		vim.list_extend(args, { "--label", "sidekick.sid=" .. self.sid, "--" })
		local t = hc(vim.list_extend(args, self:argv()), true)
		if t and t.address then
			self:set_terminal(t.address)
			return { cmd = { "hc", "attach", t.address } }
		end
		return
	end

	local ret ---@type table?
	if Config.cli.mux.create == "window" then
		local me = hc({ "get", vim.env.HC_TERMINAL_ID }, true)
		local space = me and me.labels and me.labels["herdr.space"]
		ret = herdr_do("tab.new", { space = space, folder = self.cwd, argv = self:argv() })
	else
		local pane = own_pane()
		if not pane then
			return
		end
		local argv = vim.list_extend({ "sh", "-c", SH_CD, "sh", self.cwd }, self:argv())
		local direction = Config.cli.mux.split.vertical and "right" or "down"
		ret = herdr_do("pane.split", { direction = direction, pane = pane, argv = argv })
	end

	if ret and ret.terminal then
		self:set_terminal(ret.terminal)
		self.just_started = true -- settle() decides who keeps the keyboard
		local place = Config.cli.mux.create == "window" and "tab" or "split"
		Util.info(("Started **%s** in a new herdr %s"):format(self.tool.name, place))
	end
end

function M:is_running()
	local now = vim.uv.now()
	if self._live_at and now - self._live_at < 1000 then
		return self._live
	end
	local info = self.hc_terminal and hc({ "get", self.hc_terminal })
	self._live, self._live_at = info ~= nil and info.state == "live", now
	return self._live
end

--- Live local terminals running a sidekick tool.
function M.sessions()
	local list = hc({ "ls" })
	local tools = Config.tools()

	-- pids of Neovim terminals attached to a core terminal, so the embedded
	-- terminal session wins the dedupe over this one
	local viewers = {} ---@type table<string, integer[]>
	for _, term in pairs(require("sidekick.cli.terminal").terminals) do
		local addr = term.parent and term.parent.hc_terminal
		if addr and term.pids then
			viewers[addr] = vim.list_extend(viewers[addr] or {}, term.pids)
		end
	end

	-- every terminal: `hc ls` names the shell, not the program in front of it,
	-- so only `hc get` (its foreground) can tell. The gets run in parallel
	local jobs = {}
	for _, t in ipairs(list and list.terminals or {}) do
		-- remote terminals (machine/t7) have remote cwds: skip them
		if t.state == "live" and not t.address:find("/", 1, true) and t.address ~= vim.env.HC_TERMINAL_ID then
			jobs[#jobs + 1] = { addr = t.address, job = vim.system(hc_cmd({ "get", t.address }), { text = true }) }
		end
	end

	local ret = {} ---@type sidekick.cli.session.State[]
	for _, j in ipairs(jobs) do
		local info = decode(j.job:wait().stdout)
		local fg = info and info.foreground
		if fg and fg.pid then
			---@type sidekick.cli.Proc
			local proc = {
				pid = fg.pid,
				ppid = info.pid or 0,
				cmd = table.concat(fg.argv or { fg.name or "" }, " "),
				cwd = fg.cwd or info.cwd,
			}
			for _, tool in pairs(tools) do
				if tool:is_proc(proc) then
					ret[#ret + 1] = {
						id = "hc " .. j.addr,
						cwd = proc.cwd or vim.fn.getcwd(0),
						tool = tool,
						hc_terminal = j.addr,
						external = (info.labels or {})["herdr.space"] ~= nil, -- shown as a herdr pane
						mux_session = j.addr,
						pids = vim.list_extend({ info.pid, fg.pid }, viewers[j.addr] or {}),
					}
					break
				end
			end
		end
	end
	return ret
end

--- Write raw input to the terminal through a hidden `hc attach`. Writes made
--- while the attach is open go out on it in order, PUMP_DELAY apart.
---@type table<string, {queue:string[], job?:integer, done?:boolean}>
local writers = {}

---@param data string
function M:write(data)
	local addr = self.hc_terminal
	if not addr then
		return
	end
	local w = writers[addr]
	if w then
		table.insert(w.queue, data)
		return
	end

	local info = hc({ "get", addr })
	if not info or info.state ~= "live" then
		return
	end
	w = { queue = { data } }
	writers[addr] = w

	-- false when the attach is gone (it ended before or while writing)
	local function send(chunk)
		return not w.done and pcall(vim.fn.chansend, w.job, chunk)
	end

	local ready = false
	local function pump()
		local chunk = table.remove(w.queue, 1)
		if chunk then
			if send(chunk) then
				return vim.defer_fn(pump, PUMP_DELAY)
			end
			Util.warn(("herdr terminal %s closed before the text was sent"):format(addr))
			w.queue = {}
		end
		if writers[addr] == w then
			writers[addr] = nil
		end
		if send(DETACH) then
			local job = w.job
			vim.defer_fn(function()
				if vim.fn.jobwait({ job }, 0)[1] == -1 then
					vim.fn.jobstop(job)
				end
			end, 2000)
		end
	end
	local function start()
		if not ready then
			ready = true
			vim.schedule(pump)
		end
	end

	-- same size as the terminal, so attaching doesn't resize it
	w.job = vim.fn.jobstart({ "hc", "attach", addr }, {
		pty = true,
		width = info.cols,
		height = info.rows,
		on_stdout = start, -- first paint: the stream is live
		on_exit = function()
			w.done = true
			if writers[addr] == w then
				writers[addr] = nil
			end
		end,
	})
	if w.job <= 0 then
		writers[addr] = nil
		Util.error("Failed to attach to herdr terminal " .. addr)
		return
	end
	vim.defer_fn(start, 1000) -- no paint yet: try anyway
end

---@param text string
function M:send(text)
	if self.tool.mux_focus then
		-- focus-in first (some TUI apps like qwen ignore input when unfocused)
		self:write("\27[I")
	end
	self:write(PASTE_START .. text .. PASTE_END)
end

function M:submit()
	self:write("\r")
end

function M:dump()
	if not self.hc_terminal then
		return
	end
	local _, ret = Util.exec({ "hc", "read", self.hc_terminal, "--lines", tostring(Config.cli.mux.dump) })
	return ret
end

--- Give the agent's herdr pane the keyboard (switches to its tab).
function M:focus()
	if self.external and self.hc_terminal then
		herdr_do("pane.focus", { terminal = self.hc_terminal })
	end
end

---@param session? sidekick.cli.Session
---@return sidekick.cli.muxer.Herdr?
local function herdr_pane(session)
	if session and session.backend == "herdr" and session.external then
		return session --[[@as sidekick.cli.muxer.Herdr]]
	end
end

--- The one place that decides who has the keyboard after an action on a
--- herdr pane: the agent when `want`, else Neovim again if herdr just moved
--- the keyboard to the agent's new pane (like tmux -d).
---@param session sidekick.cli.muxer.Herdr
---@param want boolean
local function settle(session, want)
	local started = session.just_started
	session.just_started = nil
	if want and M.opts.focus then
		session:focus()
	elseif started and vim.env.HC_TERMINAL_ID then
		herdr_do("pane.focus", { terminal = vim.env.HC_TERMINAL_ID })
	end
end

--- sidekick's `filter_opts` (local there): `"name"` or `{name}` into `filter`.
---@param opts? table|string
local function filter_opts(opts)
	opts = type(opts) == "string" and { name = opts } or opts or {}
	local filter = vim.deepcopy(opts.filter or {})
	filter.name = opts.name or filter.name
	return opts, filter
end

--- sidekick checks `cli.mux.backend` against its own list (tmux, zellij) and
--- errors on anything else, though registered backends work. Add "herdr" to
--- that list. `Config.validate` is looked up when the check runs (scheduled
--- after `setup()`), so wrapping it before or after setup both work.
local function patch_validate()
	local validate = Config.validate
	Config.validate = function(key, t)
		if key == "cli.mux.backend" and type(t) == "table" then
			t = vim.list_extend(vim.deepcopy(t), { "herdr" })
		end
		return validate(key, t)
	end
end

--- sidekick focuses only `state.terminal` (a Neovim window), which herdr panes
--- don't have, and has no focus hook for backends. Patch where it focuses:
--- * `State.attach` with `show` (show, select, send): focus unless
---   `focus = false`. close and hide attach without `show`: never focus
--- * `cli.toggle` and `cli.focus` show nothing and focus in their callbacks:
---   sidekick's own versions, plus a herdr branch
local function patch_focus()
	local State = require("sidekick.cli.state")
	local Cli = require("sidekick.cli")

	local attach = State.attach
	State.attach = function(state, opts)
		local ret, attached = attach(state, opts)
		local session = herdr_pane(ret and ret.session)
		if session and opts and opts.show then
			settle(session, opts.focus ~= false)
		end
		return ret, attached
	end

	Cli.toggle = function(opts)
		local filter
		opts, filter = filter_opts(opts)
		State.with(function(state, attached)
			if state.terminal then
				if not attached then
					state.terminal:toggle()
				end
				if state.terminal:is_open() and opts.focus ~= false then
					state.terminal:focus()
				end
			elseif herdr_pane(state.session) then
				-- a herdr pane can't be hidden (closing it ends the agent): focus it
				settle(state.session, opts.focus ~= false)
			end
		end, { attach = true, filter = filter })
	end

	-- blurring a herdr pane isn't possible from here: its keys go to the agent
	Cli.focus = function(opts)
		local filter
		opts, filter = filter_opts(opts)
		State.with(function(state)
			if state.terminal then
				if state.terminal:is_focused() then
					state.terminal:blur()
				else
					state.terminal:focus()
				end
			elseif herdr_pane(state.session) then
				settle(state.session, true)
			end
		end, { attach = true, filter = filter, focus = false, show = true })
	end
end

--- Register the backend, let `cli.mux.backend = "herdr"` pass validation and
--- focus herdr panes. Works before or after `require("sidekick").setup()`
--- (loaded as its lazy.nvim dependency, see plugins/ai.lua).
---@param opts? sidekick.herdr.Opts
function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
	if vim.fn.executable("hc") == 0 then
		return
	end
	patch_validate()
	require("sidekick.cli.session").register("herdr", M)
	patch_focus()
end

return M
