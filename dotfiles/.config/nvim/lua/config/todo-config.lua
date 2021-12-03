local utils = require("utils")

local function get_pattern()
  local ft_comments = {
    common = { "#", "//" },
    lua = { "--" },
    javascript = { "/\\*", "\\*" },
  }

  local pattern = table.concat(
    utils.table_map_list(
      -- Flatten the table
      vim.tbl_flatten(vim.tbl_values(ft_comments)),
      -- Suffix with the space
      function(value)
        return ("%s "):format(value)
      end
    ),
    "|"
  )

  if string.len(pattern) == 0 then
    return "\\b"
  else
    return ("(?:%s)"):format(pattern)
  end
end

local function get_ignore_args()
  local ignored = { "flow-typed" }

  local args = {}

  for _, item in ipairs(ignored) do
    table.insert(args, ("--glob=!%s"):format(item))
  end

  return table.concat(args, " ")
end

require("todo-comments").setup({
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      get_ignore_args(),
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = ([[%s(KEYWORDS):]]):format(get_pattern()), -- ripgrep regex
    -- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
})
