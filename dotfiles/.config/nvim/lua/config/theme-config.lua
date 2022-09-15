local utils = require("utils")
local constants = require("utils.constants")

local cmd = utils.cmd

local c = constants.colors

require("tokyonight").setup({
  style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim

  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value `:help attr-list`
    comments = "italic",
    keywords = "italic",
    functions = "NONE",
    variables = "NONE",
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },

  -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  sidebars = { "qf", "terminal", "packer", "help" },

  -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  day_brightness = 0.3,

  -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead.
  -- Should work with the standard **StatusLine** and **LuaLine**.
  hide_inactive_statusline = true,
  dim_inactive = false, -- dims inactive windows
  lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

  -- You can override specific color groups to use other groups or a hex color
  -- fucntion will be called with a ColorScheme table
  -- @param colors ColorScheme
  on_colors = function(colors) end,

  -- You can override specific highlights to use other groups or a hex color
  -- fucntion will be called with a Highlights and ColorScheme table
  -- @param highlights Highlights
  -- @param colors ColorScheme
  on_highlights = function(highlights, _)
    highlights.MatchParen = {
      fg = "NONE",
      bg = c.SPECIAL_GREY,
    }

    highlights.DiffDelete = {
      fg = c.COMMENT_GREY,
    }

    highlights.TelescopeMatching = highlights.Constant
  end,
})

-- Use `tokyonight` as colorscheme
cmd("colorscheme tokyonight")
