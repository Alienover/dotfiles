-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/gitsigns.lua
local utils = require("utils")
local gs = require("gitsigns")

local cmd, nmap, map = utils.cmd, utils.nmap, utils.map

local config = {
  signs = {
    add = { text = "▍" },
    change = { text = "▍" },
    delete = { text = "▸" },
    topdelete = { text = "▾" },
    changedelete = { text = "▍" },
    untracked = { text = "▍" },
  },

  preview_config = {
    border = "rounded",
  },

  on_attach = function(bufnr)
    local opts = { buffer = bufnr, silent = true, expr = true }

    local make_hunk_navigate = function(key, gs_fn)
      return function()
        if vim.wo.diff then
          return key .. "zz"
        end

        vim.schedule(function()
          gs_fn()
          cmd.call([[feedkeys("zz")]])
        end)
        return "<Ignore>"
      end
    end

    -- Navigation
    nmap("]c", make_hunk_navigate("]c", gs.next_hunk), opts)
    nmap("[c", make_hunk_navigate("[c", gs.prev_hunk), opts)

    -- Text Objects
    opts.expr = false
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
  end,
}

gs.setup(config)
