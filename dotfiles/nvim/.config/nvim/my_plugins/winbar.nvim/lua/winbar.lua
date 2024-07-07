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
  text_hl = "CursorLineNr",

  ---@type number
  -- Max depth of the upward path from current file to display
  max_path_depth = 3,

  ---@type boolean
  -- Toggle the file path
  show_filepath = true,
  ---@type boolean
  -- Toggle the symbol of the cursor word
  show_symbol = true,

  ---@type fun(): boolean
  -- Function to enable/disable the winbar
  excluded_fn = function()
    return false
  end,
  ---@type table<string>
  -- Filetype list to disable the winbar
  excluded_filetypes = {},
}

local M = {}
local MM = {}

function MM:is_excluded()
  local success, excluded = pcall(self.opts.excluded_fn, nil)
  if success and excluded then
    return true
  end

  local ft = vim.bo.filetype
  return ft == "" or vim.tbl_contains(self.opts.excluded_filetypes, ft)
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
  local name, ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")

  if name == "" then
    return
  end

  local status_ok, devicons = pcall(require, "nvim-web-devicons")

  local icon = nil
  local color, hl = "", self.opts.text_hl
  if status_ok then
    icon, color = devicons.get_icon(name, ext, { default = true })
  end

  local name_items = {
    string.format("%%#%s#%s%%*", color, icon),
    string.format("%%#%s#%s%%*", hl, name),
  }

  if vim.bo.modified then
    table.insert(
      name_items,
      string.format("%%#%s#%s%%*", "WarningMsg", self.opts.modified)
    )
  end

  table.insert(self.elements, table.concat(name_items, " "))
end

function MM:get_symbol_node()
  local status_ok, winbar = pcall(require, "lspsaga.symbol.winbar")
  if not status_ok or not self.opts.show_symbol then
    return
  end

  -- INFO: Refer to: https://nvimdev.github.io/lspsaga/breadcrumbs/#use-in-custom-statusline-or-winbar
  local symbol_node = winbar.get_bar()

  if symbol_node ~= "" then
    table.insert(self.elements, symbol_node)
  end
end

local set_winbar = function(value)
  pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
end

function M.render_winbar(opts)
  MM.opts = setmetatable(opts or {}, {
    __index = function(_, key)
      return DEFAULT_OPTS[key]
    end,
  })

  if MM:is_excluded() then
    return
  end

  MM.elements = {}

  MM:get_filepath()
  MM:get_filename()
  MM:get_symbol_node()

  if #MM.elements > 0 then
    set_winbar((" "):rep(3) .. table.concat(MM.elements, MM:separator()))
  end
end

function M.setup(opts)
  local g_ui = vim.api.nvim_create_augroup("WinbarUI", { clear = true })

  local render_winbar = function()
    coroutine.wrap(M.render_winbar)(opts)
  end

  vim.api.nvim_create_autocmd(
    { "CursorMoved", "BufWinEnter", "BufEnter", "BufWritePost" },
    {
      desc = "Winbar handler",

      group = g_ui,
      pattern = "*",
      callback = render_winbar,
    }
  )

  vim.api.nvim_create_autocmd("User", {
    desc = "Update Winbar",

    group = g_ui,
    pattern = "LspsagaUpdateSymbol",
    callback = render_winbar,
  })
end

return M
