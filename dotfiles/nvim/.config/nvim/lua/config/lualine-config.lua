-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local utils = require("custom.utils")
local icons = require("custom.icons")
local constants = require("custom.constants")

local expand = utils.expand

local c = constants.colors

---@module 'mini.icons'
local MiniIcons = utils.LazyRequire("mini.icons")

local spellcheck = {
	function()
		if vim.o.spell then
			return ("%s [%s]"):format(icons.get("extended", "spell"), vim.o.spelllang)
		end

		return ""
	end,
}

local function filename()
	local name = expand("%:t")

	if name == "" then
		return ""
	end

	local icon, hl = MiniIcons.get("file", name)

	return "%#" .. hl .. "#" .. icon .. " " .. "%*" .. "%#CursorLineNr#" .. name .. "%*"
end

local function filetype()
	local ext = expand("%:e")
	if ext == "" then
		return ""
	end

	local icon, color = MiniIcons.get("filetype", ext)
	icon = "%#" .. color .. "#" .. icon .. "%*"

	local ft = constants.filetype_mappings[vim.bo.filetype]

	return icon .. " " .. ft
end

local function encoding()
	return vim.opt.fileencoding:get():upper()
end

local diff = {
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

local spaces = {
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

local config = {
	options = {
		-- Theme
		theme = "catppuccin",

		-- Icons
		icons_enabled = true,

		-- Global line
		globalstatus = true,

		-- Symbols
		symbols = {
			error = icons.get("extended", "error") .. " ",
			warn = icons.get("extended", "warn") .. " ",
			info = icons.get("extended", "info") .. " ",
			hint = icons.get("extended", "hint") .. " ",
		},
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", diff },
		lualine_c = { spellcheck, filename },
		lualine_x = { "diagnostics", filetype },
		lualine_y = { encoding, spaces },
		lualine_z = { "location" },
	},
}

require("lualine").setup(config)
