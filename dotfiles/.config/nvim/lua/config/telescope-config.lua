-- Reference
-- https://github.com/nvim-telescope/telescope.nvim
local actions = require("telescope.actions")
local telescope = require("telescope")
local fb_actions = require("telescope").extensions.file_browser.actions

telescope.setup({
  defaults = {
    selection_caret = "  ",
    entry_prefix = "  ",

    layout_config = {
      width = 0.5,
      height = 0.5,
    },
    prompt_prefix = " 🌈 ",
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Esc>"] = actions.close,
      },
      n = {
        q = actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    undo = {
      mappings = {
        i = {
          ["<cr>"] = require("telescope-undo.actions").restore,
        },
      },
    },
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      hide_parent_dir = true,

      mappings = {
        ["i"] = {
          ["<A-r>"] = false,
          ["<A-m>"] = false,
          ["<A-y>"] = false,
          ["<A-d>"] = false,
          ["<C-r>"] = fb_actions.rename,
        },
      },
    },
  },
})

local extensions = { "fzf", "undo", "noice", "file_browser" }

for _, ext in ipairs(extensions) do
  telescope.load_extension(ext)
end
