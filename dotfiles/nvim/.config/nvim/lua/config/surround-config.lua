require("mini.surround").setup({
  -- Whether to disable showing non-error feedback
  silent = true,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    add = "s", -- Add surrounding in Normal and Visual modes
    delete = "ds", -- Delete surrounding
    replace = "cs", -- Replace surrounding

    -- Disabled
    find = "", -- Find surrounding (to the right)
    find_left = "", -- Find surrounding (to the left)
    highlight = "", -- Highlight surrounding
    update_n_lines = "", -- Update `n_lines`
    suffix_last = "", -- Suffix to search with "prev" method
    suffix_next = "", -- Suffix to search with "next" method
  },
})
