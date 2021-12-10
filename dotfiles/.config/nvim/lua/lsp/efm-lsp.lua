-- Reference
-- https://github.com/mattn/efm-langserver

local prettier = {
  formatStdin = true,
  formatCommand = (function()
    -- Faster prettier
    -- Reter to: https://github.com/mikew/prettier_d_slim
    local prettier_bin = "prettier_d_slim"

    local config_path = ""
    -- Find the prettier config under current working dir
    -- Otherwise use the common config under home dir
    if vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. "/.prettierrc")) == 1 then
      config_path = "--config " .. vim.loop.os_homedir() .. "/.prettierrc"
    end

    return ("%s %s --stdin --stdin-filepath ${INPUT}"):format(
      prettier_bin,
      config_path
    )
  end)(),
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
}

local luafmt = {
  formatStdin = true,
  formatCommand = "luafmt --stdin ${INPUT}",
}

local isort = {
  formatStdin = true,
  formatCommand = "isort --quiet -",
}

local black = {
  formatStdin = true,
  formatCommand = "black --quiet -",
}

local M = {
  init_options = { documentFormatting = true },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "css",
    "html",
    "json",
    "lua",
    "python",
  },
  settings = {
    rootMarkers = { ".git/", "package.json" },
    languages = {
      -- javascript = {eslint, prettier},
      -- javascriptreact = {eslint, prettier},
      -- ["javascript.jsx"] = {eslint, prettier},
      -- typescript = {eslint, prettier},
      -- typescriptreact = {eslint, prettier},
      -- ["typescript.tsx"] = {eslint, prettier},
      css = { prettier },
      html = { prettier },
      json = { prettier },
      lua = { luafmt },
      python = { isort, black },
    },
  },
}

-- require "lspconfig".efm.setup(M)
return M
