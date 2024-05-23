vim.notify("entering terminal")

local utils = require("utils")

local tmap = utils.tmap

local cmd, win_opt = utils.cmd, utils.wo

-- Options
cmd.setlocal("nocursorline nonumber norelativenumber")

win_opt.statuscolumn = ""

-- Keymaps
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }

tmap("<ESC>", "<C-\\><C-n>", opts)
tmap("jk", "<C-\\><C-n>", opts)
tmap("<c-w>h", "<C-\\><C-n><C-w>h", opts)
tmap("<c-w>j", "<C-\\><C-n><C-w>j", opts)
tmap("<c-w>k", "<C-\\><C-n><C-w>k", opts)
tmap("<c-w>l", "<C-\\><C-n><C-w>l", opts)
