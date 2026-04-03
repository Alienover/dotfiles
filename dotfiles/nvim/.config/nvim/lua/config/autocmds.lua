local icons = require("util.icons")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yark",
	group = vim.api.nvim_create_augroup("custom/highlight_yank", { clear = true }),

	callback = function()
		vim.hl.on_yank({ higroup = "CurSearch" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Close the listed window with `q`",
	group = vim.api.nvim_create_augroup("custom/close_by_q", { clear = true }),
	pattern = {
		"qf",
		"fzf",
		"man",
		"help",
	},

	callback = function(args)
		vim.keymap.set("n", "q", ":close<CR>", { silent = true, buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd("RecordingEnter", {
	desc = "Notify when recording starts",
	group = vim.api.nvim_create_augroup("custom/recording_start", { clear = true }),

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
	group = vim.api.nvim_create_augroup("custom/recording_end", { clear = true }),

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
	group = vim.api.nvim_create_augroup("custom/auto_resize", { clear = true }),
	command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	desc = "Custom lazy event for `BufReadPost` and `BufNewFile` event",
	group = vim.api.nvim_create_augroup("custom/lazy_post", { clear = true }),
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

vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Winbar handler",
	group = vim.api.nvim_create_augroup("custom/winbar", { clear = true }),

	callback = function()
		local winnr = vim.api.nvim_get_current_win()
		local bufnr = vim.api.nvim_win_get_buf(winnr)

		if
			not vim.api.nvim_win_get_config(winnr).zindex -- Not a floating window
			and vim.bo[bufnr].buftype == "" -- Normal buffer
			and vim.api.nvim_buf_get_name(bufnr) ~= "" -- Has a filename
			and not vim.wo[winnr].diff -- Not in diff mode
		then
			vim.wo.winbar = "%{%v:lua.require'util.winbar'.render()%}"
		end
	end,
})
