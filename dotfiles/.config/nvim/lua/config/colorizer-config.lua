local config = {
  ["*"] = {
    RRGGBBAA = true,
    css = true,
    css_fn = true,
  },
  "!notify",
  "!lazy",
}

require("colorizer").setup(config)
