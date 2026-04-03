local DEFAULT_OPTS = {
	---@type string
	-- Icon to separate the content for each section
	separator = ">",
	---@type string
	-- Highlight group for the separator
	separator_hl = "LineNr",

	---@type string
	-- Icon for the indicator about modification
	modified = "●",

	---@type string
	-- Highlight group for the content
	text_hl = "Title",

	---@type number
	-- Max depth of the upward path from current file to display
	max_path_depth = 3,

	---@type boolean
	-- Toggle the file path
	show_filepath = true,
	---@type boolean
	-- Toggle the symbol of the cursor word
	show_symbol = true,
}

local M = {}
local MM = { opts = DEFAULT_OPTS }

function MM:is_excluded()
	local winnr = vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winnr)

	return vim.api.nvim_win_get_config(winnr).zindex -- Floating window
		or vim.bo[bufnr].buftype ~= "" -- Not a normal buffer
		or vim.api.nvim_buf_get_name(bufnr) == "" -- Has no filename
		or vim.wo[winnr].diff -- In diff mode
end

function MM:separator()
	local sep, sep_hl = self.opts.separator, self.opts.separator_hl
	return string.format(" %%#%s#%s%%* ", sep_hl, sep)
end

function MM:get_filepath_depth()
	local max_path_depth = self.opts.max_path_depth
	local winnr = vim.api.nvim_get_current_win()
	local winwidth = vim.api.nvim_win_get_width(winnr)

	if winwidth > 150 then
		return max_path_depth
	elseif winwidth > 120 then
		return max_path_depth > 2 and 2 or max_path_depth
	elseif winwidth > 100 then
		return max_path_depth > 1 and 1 or max_path_depth
	elseif winwidth > 70 then
		return 1
	else
		return 0
	end
end

function MM:get_filepath()
	local show_filepath, text_hl = self.opts.show_filepath, self.opts.text_hl
	local max_path_depth = self:get_filepath_depth()

	if max_path_depth == 0 or not show_filepath then
		return
	end

	local head = vim.fn.expand("%:h")

	if head == "" or head == "." then
		return
	end

	local splitted = vim.split(head, "/")
	local paths = {}

	for i = #splitted, 1, -1 do
		if #paths < max_path_depth then
			table.insert(paths, 1, string.format("%%#%s#%s%%*", text_hl, splitted[i]))
		else
			local prefix = string.format("%%#%s#%s%%*", text_hl, "")
			table.insert(paths, 1, prefix .. " ")
			break
		end
	end

	table.insert(self.elements, table.concat(paths, self:separator()))
end

function MM:get_filename()
	local name = vim.fn.expand("%:t")

	if name == "" then
		return
	end

	local status_ok, MiniIcons = pcall(require, "mini.icons")

	local icon = nil
	local color, hl = "", self.opts.text_hl
	if status_ok then
		icon, color = MiniIcons.get("file", name)
	end

	local name_items = {
		string.format("%%#%s#%s%%*", color, icon),
		string.format("%%#%s#%s%%*", hl, name),
	}

	if vim.bo.modified then
		table.insert(name_items, string.format("%%#%s#%s%%*", "WarningMsg", self.opts.modified))
	end

	table.insert(self.elements, table.concat(name_items, " "))
end

function M.render()
	MM.elements = {}

	MM:get_filepath()
	MM:get_filename()

	return (" "):rep(3) .. table.concat(MM.elements, MM:separator())
end

return M
