local icons = require("util.icons")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yark",
	group = vim.api.nvim_create_augroup("custom/highlight_yank", { clear = true }),

	callback = function()
		vim.hl.hl_op()
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

-- INFO: `TermOpen` sets the options when the terminal is created (`buftype` is not
-- yet `terminal` during the initial `BufWinEnter`), `BufWinEnter` re-applies the
-- window-local ones when an existing terminal is shown in another window
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
	desc = "Terminal window options and keymaps",
	group = vim.api.nvim_create_augroup("custom/terminal", { clear = true }),

	callback = function(args)
		if vim.bo[args.buf].buftype ~= "terminal" then
			return
		end

		-- INFO: `number`, `relativenumber`, `list`, `signcolumn` and `foldcolumn`
		-- are already forced off by Nvim for terminal buffers
		vim.wo[vim.api.nvim_get_current_win()].cursorline = false
		vim.wo[vim.api.nvim_get_current_win()].statuscolumn = ""

		-- INFO: only map bare `:terminal` buffers. Plugin-owned terminals set their
		-- own filetype and rely on `<Esc>` reaching the tool (it is Claude's
		-- interrupt key, and lazygit/less/fzf all use it too)
		if vim.bo[args.buf].filetype ~= "" then
			return
		end

		local escape = "<C-\\><C-n>"
		local opts = { noremap = true, silent = true, buffer = args.buf }

		vim.keymap.set("t", "<Esc>", escape, opts)

		for _, dir in ipairs({ "h", "j", "k", "l" }) do
			vim.keymap.set("t", "<C-w>" .. dir, escape .. "<C-w>" .. dir, opts)
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
