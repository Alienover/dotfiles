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
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    go = { "gofmt" },
    ["*"] = { "trim_whitespace" },
  },
  format_on_save = function()
    -- Disable with a global or buffer-local variable
    local disabled = vim.F.npcall(vim.api.nvim_get_var, AUTOFORMAT) or false

    if disabled then
      return
    end

    return { timeout_ms = 500, lsp_fallback = true, async = false }
  end,
  formatters = {
    black = {
      prepend_args = { "--fast" },
    },
    stylua = {
      prepend_args = function()
        if not utils.file_existed(vim.loop.cwd() .. "/.stylua.toml") then
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
  local disabled = vim.F.npcall(vim.api.nvim_get_var, AUTOFORMAT) or false

  vim.api.nvim_set_var(AUTOFORMAT, not disabled)
end, {
  desc = "Toggle autoformat on save",
})
