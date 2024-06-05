local utils = require("utils")
local conform = require("conform")

local AUTOFORMAT = "disable_autoformat"

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
    json = { { "jq", "prettier" } },
    jsonc = { "jq", "prettier" },
    go = { "gofmt" },
    toml = { "taplo" },
    ["*"] = { "trim_whitespace" },
  },
  format_after_save = function()
    -- Disable with a global or buffer-local variable
    ---@type boolean
    local disabled = vim.F.npcall(vim.api.nvim_get_var, AUTOFORMAT) or false

    if disabled then
      return
    end

    return { lsp_fallback = true }
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

vim.api.nvim_create_user_command("ConformFormat", function()
  vim.F.npcall(conform.format, {
    async = false,
    timeout_ms = 500,
    lsp_fallback = true,
  })
end, {
  desc = "Trigger format",
})

vim.api.nvim_create_user_command("ConformToggle", function()
  ---@type boolean
  local disabled = vim.F.npcall(vim.api.nvim_get_var, AUTOFORMAT) or false

  vim.api.nvim_set_var(AUTOFORMAT, not disabled)
end, {
  desc = "Toggle autoformat on save",
})

-- INFO: overwrite the default `ConformInfo` command with customized window config
vim.api.nvim_create_user_command("ConformInfo", function()
  require("conform.health").show_window()

  vim.defer_fn(function()
    local winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_config(
      winnr,
      utils.get_float_win_opts({
        border = true,
        title = " Conform Formatters Info ",
        title_pos = "center",
      })
    )
  end, 10)
end, { desc = "Show information about Conform formatters" })
