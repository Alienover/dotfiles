local utils = require("utils")
local icons = require("utils.icons")
local consts = require("utils.constants")
local registry = require("mason-registry")

local ensure_externals = consts.ensure_externals

local sizing = utils.get_float_win_sizing()

require("mason").setup({
  ui = {
    width = sizing.width,
    height = sizing.height,
    border = "rounded",
    icons = {
      package_installed = icons.get("extended", "check"),
      package_pending = icons.get("extended", "circle"),
      package_uninstalled = icons.get("extended", "close"),
    },
  },
})

local function ensure_installed()
  for _, opts in pairs(ensure_externals) do
    local mason = opts.mason or ""

    if mason ~= "" then
      local pkg = registry.get_package(mason)
      if not pkg:is_installed() then
        pkg:install()
      end
    end
  end
end

if registry.refresh then
  registry.refresh(ensure_installed)
else
  ensure_installed()
end
