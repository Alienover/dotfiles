local utils = require("custom.utils")
local icons = require("custom.icons")

local nmap = utils.nmap

---@param name string
local augroup = function(name)
	return vim.api.nvim_create_augroup("AUTO_CREATED_GROUP_" .. name:upper(), { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yark",
	group = augroup("highlight_yank"),

	callback = function()
		vim.hl.on_yank({ higroup = "CurSearch" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Close the listed window with `q`",

	group = augroup("filetype"),
	pattern = {
		"qf",
		"fzf",
		"man",
		"help",
	},
	callback = function(args)
		nmap("q", ":close<CR>", { silent = true, buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd("RecordingEnter", {
	desc = "Notify when recording starts",
	group = augroup("recording_start"),

	callback = function()
		local reg = vim.fn.reg_recording()

		if reg ~= "" then
			vim.notify(string.format("Recording @%s...", reg), vim.log.levels.INFO, {
				id = "marco-record",
				title = " Marco",
				icon = icons.get("extended", "recording"),
				keep = function()
					return vim.fn.reg_recording() ~= ""
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	desc = "Close notify when recording leaves",
	group = augroup("recording_end"),

	callback = function()
		vim.notify("Recording stopped", vim.log.levels.INFO, {
			id = "marco-record",
			title = " Marco",
			icon = icons.get("extended", "recording"),
			timeout = 500,
		})
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	desc = "Auto resize the splits when the terminal window or tmux pane is resized",
	command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	desc = "Custom lazy event for `BufReadPost` and `BufNewFile` event",
	pattern = "*",
	once = true,

	callback = function()
		local key = "_custom_lazy_post_event_emmitted"
		if not vim.g[key] then
			vim.g[key] = true
			vim.schedule(function()
				vim.api.nvim_exec_autocmds("User", { pattern = "LazyPost" })
			end)
		end
	end,
})
