-- Refer to: https://github.com/folke/dot/blob/499fdfa47c72cefb440bff08a3e1eae19db65a8d/config/nvim/lua/util/packer.lualocal M = {}
local utils = require("utils")

local M = {}

M.local_plugins = {}

M.install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

function M.bootstrap()
  local fn = vim.fn
  if fn.empty(fn.glob(M.install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      M.install_path,
    })
  end
  vim.cmd([[packadd packer.nvim]])
  -- vim.cmd("autocmd BufWritePost plugins.lua PackerCompile") -- Auto compile when there are changes in plugins.lua
end

function M.get_name(pkg)
  local parts = vim.split(pkg, "/")
  return parts[#parts], parts[1]
end

function M.has_local(path)
  return vim.loop.fs_stat(vim.fn.expand(path)) ~= nil
end

-- This method replaces any plugins with the local clone under ~/projects
function M.process_local_plugins(spec)
  if type(spec) == "string" then
    local name, owner = M.get_name(spec)

    local local_pkg = M.local_plugins[name]
      or M.local_plugins[owner]
      or M.local_plugins[spec]

    if local_pkg and local_pkg.enabled then
      if M.has_local(local_pkg.path) then
        return local_pkg.path
      else
        utils.error("Local package " .. name .. " not found")
      end
    end
    return spec
  else
    for i, s in ipairs(spec) do
      spec[i] = M.process_local_plugins(s)
    end
  end
  if spec.requires then
    spec.requires = M.process_local_plugins(spec.requires)
  end
  return spec
end

function M.wrap(use)
  return function(spec)
    spec = M.process_local_plugins(spec)

    use(spec)
  end
end

function M.setup(fn, config)
  M.bootstrap()

  local packer = require("packer")
  packer.init(config)

  M.local_plugins = config ~= nil and config.local_plugins or {}

  return packer.startup({
    function(use)
      use = M.wrap(use)
      fn(use)
    end,
  })
end

return M
