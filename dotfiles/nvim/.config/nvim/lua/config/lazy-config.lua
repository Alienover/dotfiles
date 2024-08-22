local utils = require("utils")
local consts = require("utils.constants")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
local found, lazy = pcall(require, "lazy")
if found then
  local sizing = utils.get_float_win_sizing()

  lazy.setup({
    spec = {
      { import = "plugins" },
    },
    defaults = {
      lazy = true,
    },
    dev = {
      path = consts.LOCAL_PLUGINS_FOLDER,
      patterns = { "@local" },
      fallback = true,
    },
    install = {
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { "catppuccin-mocha" },
    },
    ui = {
      size = { width = sizing.width, height = sizing.height },
      border = "rounded",
    },
  })
else
  vim.notify("Failed to initialize lazy.nvim", vim.log.levels.ERROR)
end
