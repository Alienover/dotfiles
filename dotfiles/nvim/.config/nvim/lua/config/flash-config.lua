local utils = require("utils")
local flash = require("flash")

local map = utils.map

flash.setup({
  prompt = {
    enabled = false,
  },
  modes = {
    char = {
      jump_labels = true,
    },
    search = {
      enabled = false,
    },
  },
})

map({ "o", "x" }, "S", function()
  flash.treesitter()
end, "Flash Treesitter")

map("o", "r", function()
  flash.remote()
end, "Remote Flash")

map({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, "Treesitter Search")

map({ "c" }, "<C-f>", function()
  flash.toggle()
end, "Toggle Flash Search")
