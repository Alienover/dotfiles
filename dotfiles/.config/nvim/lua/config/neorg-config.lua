-- iCloud
local NEORG_BASE_DIR = "~/.neorg"

local config = {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.esupports.metagen"] = {
      config = {
        type = "auto",
      },
    },
    ["core.keybinds"] = {
      config = {
        neorg_leader = "g",
      },
    },
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          work = NEORG_BASE_DIR .. "/work",
          home = NEORG_BASE_DIR .. "/home",
        },
        default_workspace = "home",
      },
    },
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.upgrade"] = {},
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
