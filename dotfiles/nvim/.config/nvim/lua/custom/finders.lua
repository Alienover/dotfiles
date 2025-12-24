local M = {}

--- @param opts snacks.picker.proc.Config
--- @type snacks.picker.finder
function M.directories(opts, ctx)
	local cwd = opts.cwd or vim.uv.cwd()

	return require("snacks.picker.source.proc").proc({
		cmd = "fd",
		args = { "--type", "d", "--exclude", ".git", "--hidden", ".", cwd },
		notify = not opts.live,
		transform = function(item)
			item.cwd = cwd
			item.file = item.text:sub(#cwd + 2)
		end,
	}, ctx)
end

return M
