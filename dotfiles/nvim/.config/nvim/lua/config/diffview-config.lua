local diffview = require("diffview")

---@overload fun(): nil
---@overload fun(reset: boolean): nil
-- INFO: Inspired by https://github.com/neovim/neovim/issues/9800#issuecomment-1222229083
local function fix_cursor_underline(reset)
	reset = reset or false

	local CURSOR_HL = "CursorLine"

	local next_hl = {}
	local curr_hl = vim.F.npcall(vim.api.nvim_get_hl, 0, { name = CURSOR_HL })

	if curr_hl then
		for _, key in ipairs({ "fg", "bg" }) do
			local color = curr_hl[key]
			next_hl[key] = color and string.format("#%06x", color) or nil
		end
	end

	if not reset then
		next_hl = vim.tbl_extend("force", next_hl, { ctermfg = "white" })
	end

	vim.api.nvim_set_hl(0, CURSOR_HL, next_hl)
end

local function git_commit()
	local notify_opts = { title = "Commit" }

	local staged = vim.system({ "git", "diff", "--name-only", "--cached" }, { test = true }):wait()

	if staged.code == 0 and #vim.trim(staged.stdout) > 0 then
		vim.ui.input({ prompt = "Commit message: " }, function(msg)
			if not msg then
				return
			end

			local notify_id = vim.notify("Commiting...", vim.log.levels.INFO, notify_opts)

			vim.system({ "git", "commit", "-m", msg }, { text = true }, function(results)
				notify_opts = vim.tbl_extend("keep", notify_opts, { replace = notify_id })

				if results.code ~= 0 then
					local err_msg = table.concat({
						"Commit failed with the message:",
						vim.trim(results.stdout),
						vim.trim(results.stderr),
					}, "\n")

					vim.notify(err_msg, vim.log.levels.ERROR, notify_opts)
				else
					vim.defer_fn(function()
						diffview.emit("refresh_files")

						vim.notify(vim.trim(results.stdout), vim.log.levels.INFO, notify_opts)
					end, 100)
				end
			end)
		end)
	else
		vim.notify("no changes added to commit", vim.log.levels.WARN, notify_opts)
	end
end

local config = {
	default_args = {
		DiffviewOpen = { "--imply-local" },
		DiffviewFileHistory = { "--base=LOCAL" },
	},
	view = {
		merge_tool = {
			-- Config for conflicted files in diff views during a merge or rebase.
			layout = "diff4_mixed",
			disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
			winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
		},
	},
	keymaps = {
		file_panel = {
			{ "n", "C", git_commit, { desc = "Commit staged changes" } },
		},
	},
	hooks = {
		view_enter = function()
			fix_cursor_underline()
		end,
		view_leave = function()
			fix_cursor_underline(true)
		end,
	},
}

require("diffview").setup(config)
