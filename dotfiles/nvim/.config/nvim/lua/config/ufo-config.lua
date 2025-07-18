local ufo = require("ufo")
local utils = require("custom.utils")
local icons = require("custom.icons")

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local foldedLines = endLnum - lnum

	local suffix = ("  %s  %s %s"):format(
		icons.get("extended", "ellipsisH"),
		foldedLines,
		"line" .. (foldedLines > 1 and "s" or "")
	)

	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0

	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)

		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)

			local hlGroup = chunk[2]

			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)

			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end

			break
		end

		curWidth = curWidth + chunkWidth
	end

	table.insert(newVirtText, { suffix, "Comment" })

	return newVirtText
end

---@diagnostic disable-next-line: missing-fields
ufo.setup({
	fold_virt_text_handler = handler,
	-- @param {number} bufnr
	-- @param {string} filetype
	-- @param {any} buftype
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
	preview = {
		win_config = {
			border = { "", "─", "", "", "", "─", "", "" },
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
		},
	},
})

utils.create_keymaps(vim.tbl_map(function(preset)
	local lhs, rhs, opts = unpack(preset)

	return { "n", lhs, rhs, opts }
end, {
	{ "zR", ufo.openAllFolds, "Open All Folds" },
	{ "zM", ufo.closeAllFolds, "Close All Folds" },
	{ "zj", ufo.goNextClosedFold, "Goto [N]ext Fold" },
	{ "zk", ufo.goPreviousClosedFold, "Goto [P]revious Fold" },
	{
		"K",
		function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if winid then
				return
			end

			vim.lsp.buf.hover()
		end,
		"Peak lines if folded",
	},
}))
