local icons = require("custom.icons")
local constants = require("custom.constants")

local c = constants.colors

local M = {}

M.spellcheck = {
	function()
		if vim.o.spell then
			return ("%s [%s]"):format(icons.get("extended", "spell"), vim.o.spelllang)
		end

		return ""
	end,
}

function M.filetype()
	local icon, color = icons.get("filetype", vim.bo.filetype)
	icon = "%#" .. color .. "#" .. icon .. "%*"

	local ft = constants.filetype_mappings[vim.bo.filetype]

	return icon .. " " .. ft
end

function M.encoding()
	return vim.opt.fileencoding:get():upper()
end

M.diff = {
	"diff",
	diff_color = {
		added = { fg = c.GREEN },
		modified = { fg = c.DARK_YELLOW },
		removed = { fg = c.DARK_RED },
	},
	symbols = {
		added = icons.get("git", "add") .. " ",
		modified = icons.get("git", "modified") .. " ",
		removed = icons.get("git", "remove") .. " ",
	},
	separator = "",
}

M.spaces = {
	function()
		--- @type boolean
		local expandTab = vim.api.nvim_get_option_value("expandtab", { scope = "local" })

		if expandTab then
			local siftWidth = vim.api.nvim_get_option_value("shiftwidth", { scope = "local" })

			if siftWidth ~= 0 then
				return "Spaces: " .. siftWidth
			end
		else
			local tabStop = vim.api.nvim_get_option_value("tabstop", { scope = "local" })

			if tabStop ~= 0 then
				return "Tabs: " .. tabStop
			end
		end

		return " "
	end,
	separator = "",
}

return M
