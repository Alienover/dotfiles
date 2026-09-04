local icons = require("util.icons")

local M = {}

-- INFO: Provider selection
--
-- Mirrors the `{ "treesitter", "indent" }` provider chain that `nvim-ufo` was
-- configured with. The answer is cached in `vim.b[buf].no_ts_folds` because it
-- MUST NOT be computed inside 'foldexpr': creating a parser during fold
-- evaluation fails, and Neovim then caches `parser = nil` for the buffer and
-- returns "0" forever, silently degrading the whole buffer to the indent
-- fallback. See runtime/lua/vim/treesitter/_fold.lua.

---@param buf integer
---@return boolean has_treesitter_folds
function M.detect(buf)
	local ok, parser = pcall(vim.treesitter.get_parser, buf, nil)
	local has = ok and parser ~= nil and vim.treesitter.query.get(parser:lang(), "folds") ~= nil

	vim.b[buf].no_ts_folds = not has

	return has
end

--- Re-detect after an async parser install and force a re-evaluation of
--- 'foldexpr' when the provider actually changed. Neovim's fold cache is
--- poisoned with `parser = nil` until 'foldmethod' is bounced, so neither `zx`
--- nor reassigning 'foldexpr' is enough on its own.
---@param buf integer
function M.refresh(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	local previous = vim.b[buf].no_ts_folds

	M.detect(buf)

	if vim.b[buf].no_ts_folds == previous then
		return
	end

	-- INFO: resolve the windows showing this buffer rather than using
	-- `vim.wo[0][0]`, which would target whichever window happens to be current
	-- when an async callback fires (the bug fixed in f8c2f52)
	for _, winnr in ipairs(vim.fn.win_findbuf(buf)) do
		if vim.wo[winnr][0].foldmethod == "expr" then
			vim.api.nvim_win_call(winnr, function()
				vim.cmd("setlocal foldmethod=manual | setlocal foldmethod=expr")
			end)
		end
	end
end

---@return string
function M.foldexpr()
	if not vim.b.no_ts_folds then
		return vim.treesitter.foldexpr()
	end

	-- INFO: `indent` fallback, mirroring `foldmethod=indent`
	local lnum = vim.v.lnum

	if vim.fn.getline(lnum):match("^%s*$") then
		return "-1"
	end

	local shiftwidth = vim.fn.shiftwidth()

	return shiftwidth == 0 and "0" or tostring(math.floor(vim.fn.indent(lnum) / shiftwidth))
end

-- INFO: Fold text
--
-- 'foldtext' may return a list of `[text, highlight]` chunks, which is drawn
-- like overlay virtual text. That is how the folded line keeps its syntax
-- highlighting; Neovim's default 'foldtext' does not do this.

--- Split `line` into non-overlapping `[text, highlight]` chunks.
--- Ported from runtime/lua/vim/lsp/_folding_range.lua `spans_to_virt_text`.
---@param line string
---@param spans [integer, integer, string][] [start_col, end_col, highlight]
---@return [string, string|string[]][]
local function spans_to_chunks(line, spans)
	local bounds = { 0, #line }

	for _, span in ipairs(spans) do
		bounds[#bounds + 1] = span[1]
		bounds[#bounds + 1] = span[2]
	end

	table.sort(bounds)

	local chunks, last = {}, -1

	for _, bound in ipairs(bounds) do
		if bound > last then
			if last >= 0 then
				local hl = {}

				for _, span in ipairs(spans) do
					if span[1] <= last and bound <= span[2] and hl[#hl] ~= span[3] then
						hl[#hl + 1] = span[3]
					end
				end

				chunks[#chunks + 1] = { line:sub(last + 1, bound), #hl > 0 and hl or "Folded" }
			end

			last = bound
		end
	end

	return chunks
end

--- Treesitter-highlighted chunks for a single line.
---@param buf integer
---@param lnum integer
---@return [string, string|string[]][]
local function line_chunks(buf, lnum)
	local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""

	-- INFO: virtual text does not expand tabs
	line = line:gsub("\t", (" "):rep(vim.bo[buf].tabstop))

	if vim.b[buf].no_ts_folds then
		return { { line, "Folded" } }
	end

	local ok, parser = pcall(vim.treesitter.get_parser, buf, nil)
	if not ok or not parser then
		return { { line, "Folded" } }
	end

	-- INFO: parse the single line in isolation. Cheap, and safe under the
	-- textlock that applies while 'foldtext' is being evaluated.
	local parsed, line_parser = pcall(vim.treesitter.get_string_parser, line, parser:lang())
	if not parsed then
		return { { line, "Folded" } }
	end

	line_parser:parse(true)

	local spans = {}

	line_parser:for_each_tree(function(tstree, tree)
		local query = vim.treesitter.query.get(tree:lang(), "highlights")
		if not query then
			return
		end

		for capture, node in query:iter_captures(tstree:root(), line) do
			local name = query.captures[capture]

			if name:match("^[^_]") then
				local _, start_col, _, end_col = node:range()

				spans[#spans + 1] = { start_col, end_col, ("@%s.%s"):format(name, tree:lang()) }
			end
		end
	end)

	return spans_to_chunks(line, spans)
end

---@return [string, string|string[]][]
function M.foldtext()
	local buf = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()

	local lnum, endlnum = vim.v.foldstart, vim.v.foldend
	local folded_lines = endlnum - lnum

	local ellipsis = icons.get("extended", "ellipsisH")
	local suffix = ("  %s  %s %s"):format(ellipsis, folded_lines, "line" .. (folded_lines > 1 and "s" or ""))

	local width = vim.api.nvim_win_get_width(winnr) - vim.fn.getwininfo(winnr)[1].textoff
	local target_width = width - vim.fn.strdisplaywidth(suffix)

	local chunks, cur_width = {}, 0

	for _, chunk in ipairs(line_chunks(buf, lnum)) do
		local chunk_width = vim.fn.strdisplaywidth(chunk[1])

		if target_width > cur_width + chunk_width then
			chunks[#chunks + 1] = chunk
		else
			local text = vim.fn.strcharpart(chunk[1], 0, math.max(target_width - cur_width, 0))

			chunks[#chunks + 1] = { text, chunk[2] }
			chunk_width = vim.fn.strdisplaywidth(text)

			-- INFO: truncated width may be less than requested, pad the suffix
			if cur_width + chunk_width < target_width then
				suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
			end

			break
		end

		cur_width = cur_width + chunk_width
	end

	chunks[#chunks + 1] = { suffix, "Comment" }

	return chunks
end

-- INFO: Peek
--
-- Replaces `nvim-ufo`'s `peekFoldedLinesUnderCursor`. Not feature equivalent:
-- ufo could scroll the preview from the parent window, this closes as soon as
-- the cursor moves and focuses the float when re-invoked.

local peek_win = nil

---@return integer? winid
function M.peek()
	if peek_win and vim.api.nvim_win_is_valid(peek_win) then
		vim.api.nvim_set_current_win(peek_win)

		return peek_win
	end

	local lnum = vim.fn.foldclosed(".")
	if lnum == -1 then
		return nil
	end

	local endlnum = vim.fn.foldclosedend(".")
	local buf = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local textoff = vim.fn.getwininfo(winnr)[1].textoff

	-- INFO: reuse the same buffer with folds disabled, so highlighting,
	-- extmarks and signs come for free
	peek_win = vim.api.nvim_open_win(buf, false, {
		relative = "cursor",
		row = 1,
		col = -textoff,
		width = vim.api.nvim_win_get_width(winnr) - textoff,
		height = math.max(math.min(endlnum - lnum + 1, math.floor(vim.o.lines * 0.4)), 1),
		style = "minimal",
		border = { "", "─", "", "", "", "─", "", "" },
		focusable = true,
		noautocmd = true,
	})

	vim.wo[peek_win].foldenable = false
	vim.wo[peek_win].winblend = 0

	vim.api.nvim_win_set_cursor(peek_win, { lnum, 0 })
	vim.api.nvim_win_call(peek_win, function()
		vim.cmd("normal! zt")
	end)

	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave", "WinScrolled" }, {
		group = vim.api.nvim_create_augroup("custom/fold_peek", { clear = true }),
		once = true,

		callback = function()
			if peek_win and vim.api.nvim_win_is_valid(peek_win) then
				vim.api.nvim_win_close(peek_win, true)
			end

			peek_win = nil
		end,
	})

	return peek_win
end

return M
