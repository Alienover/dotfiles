local utils = require("utils")
local consts = require("utils.constants")

local icons = consts.icons

local M = {}

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  ---@diagnostic disable-next-line: undefined-field
  vim.opt.rtp:prepend(lazypath)
end

function M.setup(plugins)
  M.bootstrap()

  local sizing = utils.get_float_win_sizing()

  require("lazy").setup(plugins, {
    defaults = {
      lazy = true,
    },
    dev = {
      path = consts.LOCAL_PLUGINS_FOLDER,
    },
    install = {
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { "tokyonight" },
    },
    ui = {
      size = { width = sizing.width, height = sizing.height },
      border = "rounded",
      icons = {
        cmd = icons.misc.Command,
        config = icons.ui.Gear,
        event = icons.kind.Event,
        ft = icons.ui.NewFile,
        init = icons.ui.BigUnfilledCircle,
        keys = icons.misc.Keyboard,
        plugin = icons.kind.Function,
        runtime = icons.misc.Watch,
        source = icons.ui.Note,
        start = icons.ui.Circle,
        task = icons.ui.Comment,
      },
    },
  })
end

return M
