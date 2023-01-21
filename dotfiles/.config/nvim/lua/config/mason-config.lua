local utils = require("utils")
local consts = require("utils.constants")

local icons = consts.icons

local M = {}

M.setup = function(servers)
  local sizing = utils.get_float_win_sizing()

  require("mason").setup({
    ui = {
      width = sizing.width,
      height = sizing.height,
      border = "rounded",
      icons = {
        package_installed = icons.ui.Check,
        package_pending = icons.ui.Circle,
        package_uninstalled = icons.ui.Close,
      },
    },
  })

  require("mason-lspconfig").setup({ ensure_installed = servers })
end

return M
