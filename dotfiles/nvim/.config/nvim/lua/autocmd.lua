local utils = require("utils")
local consts = require("utils.constants")

local nmap = utils.nmap

local groups = {
  filetype = vim.api.nvim_create_augroup("FT", { clear = true }),
  linting = vim.api.nvim_create_augroup("Linting", { clear = true }),
}

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
    nmap("q", ":close<CR>", { silent = true, buffer = 0 })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  desc = "Trigger the linting",

  group = groups.linting,
  callback = function()
    require("lint").try_lint()
  end,
})
