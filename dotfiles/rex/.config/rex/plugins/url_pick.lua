-- Pick a URL from the focused pane and open it. Finds plain URLs in
-- the screen and scrollback, plus OSC 8 hyperlinks (text whose target isn't
-- shown, as printed by `ls --hyperlink`, gh, delta, ...). Newest first.
local M = {}

local TERMINAL = "com.superlogical.terminal"
-- format and blob_read return at most this many bytes per reply
local CHUNK = 983040

-- Rex's Lua overflows on table.concat of many thousands of pieces, so join
-- them a batch at a time.
local function join(parts)
	while #parts > 1 do
		local joined = {}
		for i = 1, #parts, 1000 do
			table.insert(joined, table.concat(parts, "", i, math.min(i + 999, #parts)))
		end
		parts = joined
	end
	return parts[1] or ""
end

local function exists(path)
	local f = io.open(path, "r")
	if f == nil then
		return false
	end
	f:close()
	return true
end

local mac = exists("/usr/bin/open")

local defaults = {
	open = mac and { "open" } or { "xdg-open" },
	-- Schemes of plain URLs to look for. OSC 8 links are kept whatever theirs.
	schemes = { "http", "https", "file", "ftp", "ssh", "git", "git+ssh" },
	limit = 500,
}

local entities = { amp = "&", lt = "<", gt = ">", quot = '"', apos = "'", nbsp = " " }

local function decode(s)
	return (s:gsub("&(#?x?)(%w+);", function(kind, name)
		if kind == "" then
			return entities[name]
		end
		local n = tonumber(name, kind == "#x" and 16 or 10)
		if n ~= nil and n < 128 then
			return string.char(n)
		end
	end))
end

-- Capture the pane as HTML. When it's too big for one reply, keep the end,
-- since the newest URLs are the ones worth picking.
local function capture(block_id)
	local args = { block_id = block_id, format = "html", unwrap = true, max_bytes = CHUNK }
	local r, err = rex.block.call(TERMINAL, "format", args)
	if r == nil then
		error(err, 0)
	end
	if r.id == nil then
		return r.content
	end
	local parts, offset = {}, math.max(0, (r.total or 0) - CHUNK)
	repeat
		local tail, terr = rex.block.call(TERMINAL, "blob_read", {
			block_id = block_id,
			id = r.id,
			offset = offset,
			max_bytes = CHUNK,
		})
		if tail == nil then
			error(terr, 0)
		end
		table.insert(parts, tail.data)
		offset = offset + #tail.data
	until tail.eof or tail.data == ""
	local content = join(parts)
	-- The cut can land inside a tag; start at the next whole line.
	return content:match("\n(.*)$") or content
end

-- Strip the tags, which split a URL wherever its colours change, and note
-- where each <a href> sits in the resulting text.
local function parse(html)
	local parts, links, len, pos, open = {}, {}, 0, 1, nil
	while true do
		local s = html:find("<", pos, true)
		local chunk = decode(html:sub(pos, (s or 0) - 1))
		table.insert(parts, chunk)
		len = len + #chunk
		if s == nil then
			break
		end
		local e = html:find(">", s, true)
		if e == nil then
			break
		end
		local tag = html:sub(s + 1, e - 1)
		local href = tag:match('^a%s.-href="([^"]*)"')
		if href ~= nil then
			open = { at = len + 1, url = decode(href) }
			table.insert(links, open)
		elseif tag == "/a" and open ~= nil then
			open.stop = len
			open = nil
		end
		pos = e + 1
	end
	local text = join(parts)
	for _, link in ipairs(links) do
		link.label = text:sub(link.at, link.stop or link.at - 1)
	end
	return text, links
end

local closers = { [")"] = "(", ["]"] = "[", ["}"] = "{" }

local function count(s, c)
	local _, n = s:gsub("%" .. c, "")
	return n
end

-- Drop what a URL is usually followed by in prose: "see https://x.com/a)."
local function trim_url(url)
	while true do
		local last = url:sub(-1)
		local opener = closers[last]
		if last:match("[%.,;:!%?'\"]") or (opener and count(url, last) > count(url, opener)) then
			url = url:sub(1, -2)
		else
			return url
		end
	end
end

local function find_urls(text, schemes)
	local found, init = {}, 1
	while true do
		local s, e, scheme = text:find("(%a[%w+.-]*)://", init)
		if s == nil then
			return found
		end
		init = e + 1
		if schemes[scheme:lower()] then
			local rest = text:match("^[^%s<>\"'`{}|\\^]+", e + 1)
			if rest ~= nil then
				local url = trim_url(text:sub(s, e) .. rest)
				if #url > e - s + 1 then
					table.insert(found, { at = s, url = url })
					init = s + #url
				end
			end
		end
	end
end

local function icon(url)
	local scheme = url:match("^(%a[%w+.-]*):") or ""
	scheme = scheme:lower()
	if scheme == "http" or scheme == "https" then
		return "globe"
	elseif scheme == "file" then
		return "document"
	end
	return "link"
end

local function items(block_id, opts)
	local text, links = parse(capture(block_id))
	local all = find_urls(text, opts.schemes)
	for _, link in ipairs(links) do
		if link.url ~= "" then
			table.insert(all, link)
		end
	end
	table.sort(all, function(a, b)
		return a.at > b.at
	end)

	local list, seen = {}, {}
	for _, hit in ipairs(all) do
		if not seen[hit.url] then
			seen[hit.url] = true
			local label = hit.label and hit.label:gsub("%s+", " ")
			table.insert(list, {
				id = hit.url,
				subtitle = label ~= nil and label ~= hit.url and label ~= "" and label or nil,
				icon = icon(hit.url),
				detail = hit.label and "link" or nil,
			})
			if #list >= opts.limit then
				break
			end
		end
	end
	return list
end

-- file://host/path from `ls --hyperlink` names this machine's host, which
-- `open` doesn't accept. Open it as file:///path.
local function localize(url)
	return (url:gsub("^file://[^/]+/", "file:///"))
end

function M.setup(opts)
	opts = opts or {}
	opts.open = opts.open or defaults.open
	opts.limit = opts.limit or defaults.limit
	local schemes = {}
	for _, s in ipairs(opts.schemes or defaults.schemes) do
		schemes[s] = true
	end
	opts.schemes = schemes

	rex.action({
		name = "url_open",
		title = "Open URL from Pane…",
		run = function(ctx)
			if ctx.block_id == nil then
				return
			end
			local list = items(ctx.block_id, opts)
			local url, why, detail = rex.ui.pick({
				title = #list > 0 and "Open URL" or "No URLs in this pane",
				placeholder = "Filter URLs",
				items = list,
				confirm = "Open",
			})
			if url == nil then
				if why ~= "cancelled" then
					rex.log("warn", "url_pick: " .. why .. " " .. (detail or ""))
				end
				return
			end

			local argv = { unpack(opts.open) }
			table.insert(argv, localize(url))
			local r, err = rex.exec(argv, { timeout = 5 })
			if r == nil then
				error(err, 0)
			end
			if not r.ok then
				error(r.stderr ~= "" and r.stderr or (argv[1] .. " failed"), 0)
			end
		end,
	})
end

return M
