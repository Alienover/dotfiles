local utils = require("utils")
local flash = require("flash")

local map = utils.map

local config = {
  prompt = {
    enabled = false,
  },
}

flash.setup(config)

local opts = function(desc)
  return {
    noremap = true,
    silent = true,
    desc = desc,
  }
end

map({ "o", "x" }, "S", function()
  flash.treesitter()
end, opts("Flash Treesitter"))

map("o", "r", function()
  flash.remote()
end, opts("Remote Flash"))

map({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, opts("Treesitter Search"))

map({ "c" }, "<C-s>", function()
  flash.toggle()
end, opts("Toggle Flash Search"))
