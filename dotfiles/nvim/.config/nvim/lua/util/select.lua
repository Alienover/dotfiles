local M = {}

---@type table<string, snacks.picker.Config>
local snacks_select_layouts = {
	codeaction = {
		layout = {
			layout = {
				relative = "cursor",
				row = 1.01,
			},
		},
	},
	color_presentation = {
		layout = {
			layout = {
				relative = "cursor",
				row = 1.01,
			},
		},
	},
}

function M.select(items, opts, on_choice)
	local preset = snacks_select_layouts[opts.kind]

	---@type snacks.picker.Config
	opts.snacks = {}

	if preset then
		opts.snacks = preset
	end

	if #items > 0 then
		require("snacks.picker.select").select(items, opts, on_choice)
	end
end

return M
