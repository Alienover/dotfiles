-- iCloud
local NEORG_BASE_DIR = "~/.neorg"

local config = {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.norg.esupports.metagen"] = {
      config = {
        type = "auto",
      },
    },
    ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.norg.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          work = NEORG_BASE_DIR .. "/work",
          home = NEORG_BASE_DIR .. "/home",
        },
        default_workspace = "home",
      },
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
  },
}

local setup = function()
  local success, neorg = pcall(require, "neorg")
  if not success then
    return
  end

  neorg.setup(config)
end

setup()
