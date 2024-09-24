return {
  {
    "yetone/avante.nvim",
    enabled = false,
    cmd = { "AvanteAsk" },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    opts = {
      provider = "claude",
      claude = {
        api_key_name = "cmd:pass show Anthropic/neovim-key",
      },
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("avante.api").ask()
        end,
        desc = "avante: ask",
        mode = { "n", "v" },
      },
      {
        "<leader>ar",
        function()
          require("avante.api").refresh()
        end,
        desc = "avante: refresh",
      },
      {
        "<leader>ae",
        function()
          require("avante.api").edit()
        end,
        desc = "avante: edit",
        mode = "v",
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional,
      "echasnovski/mini.icons",
    },
  },
}
