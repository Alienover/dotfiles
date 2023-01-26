-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/gitsigns.lua
local utils = require("utils")
local gs = require("gitsigns")

local cmd, nmap, map = utils.cmd, utils.nmap, utils.map

local config = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "▍",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "▍",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "▸",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "▾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "▍",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
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
