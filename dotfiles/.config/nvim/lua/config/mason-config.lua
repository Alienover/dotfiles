local consts = require('utils.constants')

require("mason").setup({
  ui = {
    icons = {
      package_installed = consts.icons.ui.Check,
      package_pending = consts.icons.ui.Circle,
      package_uninstalled = consts.icons.ui.Close,
    },
  },
})
