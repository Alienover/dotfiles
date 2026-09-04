local icons = require("util.icons")
local constants = require("util.constants")

-- INFO: source colours from the colorscheme rather than `GUI_*` env vars, which
-- are only exported by an interactive shell -- a GUI-launched nvim got empty
-- strings, and lualine renders those as `guifg=None` with no error
local c = require("catppuccin.palettes").get_palette("mocha")

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
		added = { fg = c.green },
		modified = { fg = c.peach },
		removed = { fg = c.red },
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
