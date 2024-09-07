local utils = require("utils")
local conform = require("conform")

local AUTO_FORMAT = "conform_autoformat"

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    html = { "prettier" },
    yaml = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "jq", "prettier", stop_after_first = true },
    jsonc = { "jq", "prettier" },
    go = { "gofmt" },
    toml = { "taplo" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = function()
    -- Disable with a global or buffer-local variable
    ---@type boolean
    local enabled = vim.F.npcall(vim.api.nvim_get_var, AUTO_FORMAT) or true

    if not enabled then
      return
    end

    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
  formatters = {
    black = {
      prepend_args = { "--fast" },
    },
    taplo = {
      args = {
        "format",
        "--option",
        "column_width=120",
        "-",
      },
    },
    stylua = {
      prepend_args = function()
        if not utils.file_existed(vim.fn.getcwd(0) .. "/.stylua.toml") then
          return {
            "--indent-width",
            "2",
            "--indent-type",
            "Spaces",
            "--column-width",
            "80",
          }
        else
          return {}
        end
      end,
    },
  },
})

utils.create_commands({
  -- Format Trigger
  {
    "ConformFormat",
    function()
      vim.F.npcall(conform.format, {
        async = false,
        timeout_ms = 500,
        lsp_format = "fallback",
      })
    end,
    desc = "Trigger format",
  },

  -- Toggle
  {
    "ConformToggle",
    function()
      ---@type boolean
      local enabled = vim.F.npcall(vim.api.nvim_get_var, AUTO_FORMAT) or true

      vim.api.nvim_set_var(AUTO_FORMAT, not enabled)
    end,
    desc = "Toggle autoformat on save",
  },

  -- Formatter Info
  {
    "ConformInfo",
    function()
      require("conform.health").show_window()

      vim.schedule(function()
        local winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_config(
          winnr,
          utils.get_float_win_opts({
            border = true,
            title = " Conform Formatters Info ",
            title_pos = "center",
          })
        )
      end)
    end,
    desc = "Show information about Conform formatters",
  },
})
