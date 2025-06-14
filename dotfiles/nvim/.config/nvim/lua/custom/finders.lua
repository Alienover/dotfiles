local M = {}

--- @param opts snacks.picker.proc.Config
--- @type snacks.picker.finder
function M.directories(opts, ctx)
	local cwd = opts.cwd or vim.uv.cwd()

	local cmd = "fd"
	local args = { "--type", "d", "--hidden", ".", cwd }

	return require("snacks.picker.source.proc").proc({
		opts,
		{
			cmd = cmd,
			args = args,
			notify = not opts.live,
			transform = function(item)
				item.cwd = cwd
				item.file = item.text
			end,
		},
	}, ctx)
end

return M
