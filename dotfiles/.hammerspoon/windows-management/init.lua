local hhtwm = require("hhtwm")
local conf = require("windows-management/conf")

local log = hs.logger.new("wm", "info")

local M = {
  hhtwm = hhtwm,
}

M.init = function()
  local filters = {
    { app = "Finder", tile = false },
    { app = "WeChat", tile = false },
    { app = "QQ", tile = false },
  }

  local menuBarHeight = hs.screen.primaryScreen():frame().y

  local margin = 12
  local halfMargin = margin / 2

  local screenMargin = {
    top = menuBarHeight + halfMargin,
    bottom = halfMargin,
    left = halfMargin,
    right = halfMargin,
  }

  hhtwm.marign = margin
  hhtwm.screenMargin = screenMargin
  hhtwm.filters = filters
  hhtwm.displayLayouts = conf.defaultDisplayLayouts
  hhtwm.defaultLayout = "monocle"

  hhtwm.start()
end

return M
