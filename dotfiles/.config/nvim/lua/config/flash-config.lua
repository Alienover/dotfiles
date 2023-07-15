local utils = require("utils")
local flash = require("flash")

local map = utils.map

local config = {
  modes = {
    char = {
      keys = { "t", "T" },
    },
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

map({ "n", "x", "o" }, "f", function()
  flash.jump({
    search = {
      mode = function(str)
        return "\\<" .. str
      end,
    },
  })
end, opts("Flash"))

map({ "o", "x" }, "S", function()
  flash.treesitter()
end, opts("Flash Treesitter"))

map("o", "r", function()
  flash.remote()
end, opts("Remote Flash"))

map({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, opts("Treesitter Search"))
