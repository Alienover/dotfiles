local M = {}

local alias = {
  laptop = "Built-in Retina Display",
  monitor = "PHL 272B7QPJ",
}

M = {
  alias = alias,
  defaultDisplayLayouts = {
    [alias.laptop] = "floating",
    [alias.monitor] = "monocle",
  },
  displayLayouts = {
    [alias.laptop] = { "monocle", "main-right", "side-by-side" },
    [alias.monitor] = {
      "monocel",
      "main-center",
      "main-right",
      "side-by-side",
    },
  },
}

return M
