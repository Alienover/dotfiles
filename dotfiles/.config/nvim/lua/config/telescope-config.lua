-- Reference
-- https://github.com/nvim-telescope/telescope.nvim
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
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
  },
})

require("telescope").load_extension("fzf")
