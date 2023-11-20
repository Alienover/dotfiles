local utils = require("utils")
local conform = require("conform")

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
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },
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
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, {})
