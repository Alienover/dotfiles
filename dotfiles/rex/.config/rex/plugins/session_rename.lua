-- Rename the current session from a picker of predefined names. The names are
-- the ones tmux-switchy knows: its built-in mappings plus ~/.tmux_session
-- (`key=name` per line, `#` for comments). Typing a name that isn't in the
-- list is accepted too.
local M = {}

local defaults = {
	-- Keep in sync with SESSION_MAPPINGS in ~/.local/bin/tmux-switchy
	names = {
		term = "🦄 term",
		obsidian = "📚 Obsidian",
		vpn = "🌈 vpn",
	},
	file = os.getenv("HOME") .. "/.tmux_session",
}

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Same format and rules as load_session_mappings in tmux-switchy
local function load_file(path, names)
	local f = io.open(path, "r")
	if f == nil then
		return
	end
	for line in f:lines() do
		if not line:match("^%s*#") then
			local key, value = line:match("^([^=]*)=(.*)$")
			if key ~= nil then
				key, value = trim(key), trim(value)
				if key ~= "" and value ~= "" then
					names[key] = value
				end
			end
		end
	end
	f:close()
end

local function items(opts, current)
	local names = {}
	for key, value in pairs(opts.names) do
		names[key] = value
	end
	load_file(opts.file, names)

	local keys = {}
	for key in pairs(names) do
		table.insert(keys, key)
	end
	table.sort(keys)

	local list, seen = {}, {}
	for _, key in ipairs(keys) do
		local label = names[key]
		if not seen[label] then
			seen[label] = true
			table.insert(list, {
				id = label,
				subtitle = key,
				icon = "tag",
				detail = label == current and "current" or nil,
			})
		end
	end
	return list
end

function M.setup(opts)
	opts = opts or {}
	opts.names = opts.names or defaults.names
	opts.file = opts.file or defaults.file

	rex.action({
		name = "session_rename",
		title = "Rename Session…",
		args = { label = "string?" },
		run = function(ctx, args)
			local label = args.label
			if label == nil then
				local view = rex.session.view({ session_id = ctx.session_id }) or {}
				local answer, why, detail = rex.ui.pick({
					title = "Rename session",
					placeholder = view.label or "Session name",
					items = items(opts, view.label),
					allow_other = true,
					confirm = "Rename",
				})
				if answer == nil then
					if why ~= "cancelled" then
						rex.log("warn", "session_rename: " .. why .. " " .. (detail or ""))
					end
					return
				end
				label = type(answer) == "table" and answer.text or answer
			end

			label = trim(label)
			if label == "" then
				return
			end
			local _, err = rex.session.set_label({ session_id = ctx.session_id, label = label })
			if err ~= nil then
				error(err, 0)
			end
		end,
	})
end

return M
