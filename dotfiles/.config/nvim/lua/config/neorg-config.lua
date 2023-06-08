local icons = require("utils.icons")

-- iCloud
local NEORG_BASE_DIR = "~/.neorg"

local config = {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.esupports.metagen"] = {
      config = {
        tab = "  ",
        type = "auto",
      },
    },
    ["core.keybinds"] = {
      config = {
        neorg_leader = "g",
        hook = function(keybinds)
          keybinds.unmap("norg", "n", "gf")
          keybinds.unmap("norg", "n", "gF")

          keybinds.remap_event(
            "norg",
            "n",
            "ge",
            "core.looking-glass.magnify-code-block"
          )

          keybinds.remap_event(
            "norg",
            "n",
            "<C-s>",
            "core.integrations.telescope.find_linkable"
          )
          keybinds.remap_event(
            "norg",
            "i",
            "<C-l>",
            "core.integrations.telescope.insert_link"
          )

          keybinds.remap_event(
            "norg",
            "i",
            "<C-f>",
            "core.integrations.telescope.insert_file_link"
          )
        end,
      },
    },
    ["core.concealer"] = {
      config = {
        icons = {
          todo = {
            pending = {
              icon = icons.ui.Minus,
            },
            undone = {
              icon = icons.ui.Close,
            },
          },
        },
      },
    }, -- Adds pretty icons to your documents
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
    ["core.integrations.telescope"] = {},
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
