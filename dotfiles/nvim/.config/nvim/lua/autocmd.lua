local utils = require("custom.utils")
local icons = require("custom.icons")
local consts = require("custom.constants")

local nmap = utils.nmap

---@type table<string, integer>
local augroups = setmetatable({
	__groups = {},
}, {
	__index = function(t, k)
		if not t.__groups[k] then
			t.__groups[k] = vim.api.nvim_create_augroup("AUTO_CREATED_GROUP_" .. k, { clear = true })
		end

		return t.__groups[k]
	end,
})

-- FIXME: need to find a way to set the filetype
-- using `pattern` in vim.filetype.add
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Set filetype to terminal",
	group = augroups.terminal,

	command = "set filetype=terminal",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yark",

	callback = function()
		vim.highlight.on_yank({})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Close the listed window with `q`",

	group = augroups.filetype,
	pattern = consts.special_filetypes.close_by_q,
	callback = function(args)
		nmap("q", ":close<CR>", { silent = true, buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	desc = "Trigger the formatting",

	group = augroups.formatting,
	callback = function(args)
		if vim.bo.filetype == "oil" then
			return
		end

		vim.lsp.buf.format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd("RecordingEnter", {
	desc = "Notify when recording starts",
	group = augroups.recording,

	callback = function()
		local reg = vim.fn.reg_recording()

		if reg ~= "" then
			vim.g.recording_notify_id = vim.notify(string.format("Recording @%s...", reg), vim.log.levels.INFO, {
				title = " Marco",
				icon = icons.get("extended", "recording"),
				replace = vim.g.recording_notify_id,
				keep = function()
					return vim.fn.reg_recording() ~= ""
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	desc = "Close notify when recording leaves",
	group = augroups.recording,

	callback = function()
		local last_id = vim.g.recording_notify_id

		if last_id then
			vim.notify("Recording stopped", vim.log.levels.INFO, {
				title = " Marco",
				icon = icons.get("extended", "recording"),
				timeout = 100,
				replace = last_id,
			})
		end

		vim.g.recording_notify_id = nil
	end,
})
