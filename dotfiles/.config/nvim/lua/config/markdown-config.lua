local utils = require("utils")

local cmd, setup_global = utils.cmd, utils.setup_global

-- FIXME: turn this to lua function
cmd([[
  function OpenMarkdownPreview (url)
    execute "silent ! open -a Safari " . a:url
  endfunction
]])

local global = {
  -- recognized filetypes
  -- these filetypes will have MarkdownPreview... commands
  mkdp_filetypes = { "markdown" },

  -- a custom vim function name to open preview page
  -- this function will receive url as param
  -- default is empty
  mkdp_browserfunc = "OpenMarkdownPreview",
}

setup_global(global)
