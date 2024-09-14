local function get_ignore_args()
  local ignored = { "flow-typed", "node_modules" }

  return string.format("--glob=!{%s}", table.concat(ignored, ","))
end

require("todo-comments").setup({
  signs = false,
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      get_ignore_args(),
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
})
