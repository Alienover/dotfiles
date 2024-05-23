local utils = require("utils")
local consts = require("utils.constants")

local nmap = utils.nmap

local groups = {
  filetype = vim.api.nvim_create_augroup("FT", { clear = true }),
  folding = vim.api.nvim_create_augroup("Folding", { clear = true }),
  terminal = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  linting = vim.api.nvim_create_augroup("Linting", { clear = true }),
}

-- vim.api.nvim_create_autocmd("TermEnter", {
--   desc = "Set terminal filetype as default",
--
--   group = groups.terminal,
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local curr_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
--
--     if curr_ft == "" then
--       vim.cmd.set("filetype=terminal")
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yark",

  callback = function()
    vim.highlight.on_yank({})
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close the listed window with `q`",

  group = groups.filetype,
  pattern = consts.special_filetypes.close_by_q,
  callback = function()
    nmap("q", function()
      utils.cmd("close")
    end, { silent = true, buffer = 0 })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  desc = "Trigger the linting",

  group = groups.linting,
  callback = function()
    require("lint").try_lint()
  end,
})
