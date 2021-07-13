-- Reference
-- https://github.com/simrat39/symbols-outline.nvim

local Utils = require "utils"

local g, cmd = Utils.g, Utils.cmd

g.symbols_outline = {
    keymaps = {
        close = "q",
        hover_symbol = "<C-k>"
    }
}
