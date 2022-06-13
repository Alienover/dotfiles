local utils = require("utils")
local constants = require("utils.constants")

local nmap, tmap, expand = utils.nmap, utils.tmap, utils.expand

local groups = {
  terminal = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  diff = vim.api.nvim_create_augroup("Diff", { clear = true }),
  filetype = vim.api.nvim_create_augroup("FT", { clear = true }),
  folding = vim.api.nvim_create_augroup("Folding", { clear = true }),
  directory = vim.api.nvim_create_augroup("Directory", { clear = true }),
}

vim.api.nvim_create_autocmd("TermEnter", {
  desc = "Remove the editor styling and define keymaps on entering terminal",

  callback = function()
    local excluded_filetypes = { "rnvimr", "fzf" }
    local curr_ft = vim.api.nvim_buf_get_option(0, "filetype")

    if vim.tbl_contains(excluded_filetypes, curr_ft) then
      return
    end

    utils.cmd("setlocal nocursorline nonumber norelativenumber")
    -- Set darker background color
    utils.cmd("hi TerminalBG guibg=" .. constants.colors.BLACK)
    utils.cmd("set winhighlight=Normal:TerminalBG")

    -- Keymaps
    local opts = { noremap = true, silent = true, buffer = 0 }
    tmap("<ESC>", "<C-\\><C-n>", opts)
    tmap("jk", "<C-\\><C-n>", opts)
    tmap("<c-w>h", "<C-\\><C-n><C-w>h", opts)
    tmap("<c-w>j", "<C-\\><C-n><C-w>j", opts)
    tmap("<c-w>k", "<C-\\><C-n><C-w>k", opts)
    tmap("<c-w>l", "<C-\\><C-n><C-w>l", opts)
  end,
  group = groups.terminal,
})

local function toggleCursorLine(val, scope)
  return function()
    if vim.api.nvim_win_get_option(0, "diff") then
      local cmd = {}

      if scope == "local" then
        table.insert(cmd, "setlocal")
      else
        table.insert(cmd, "set")
      end

      if val == true then
        table.insert(cmd, "cursorline")
      else
        table.insert(cmd, "nocursorline")
      end

      vim.cmd(table.concat(cmd, " "))
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Disable the cursorline to remove the annoying underling",

  callback = toggleCursorLine(false, "local"),
  group = diffGroup,
})
vim.api.nvim_create_autocmd("BufLeave", {
  desc = "Enable again when leave the buffer",

  callback = toggleCursorLine(true, "local"),
  group = diffGroup,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yark",

  callback = function()
    vim.highlight.on_yank({})
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close the listed window with `q`",

  group = groups.filetype,
  pattern = {
    "fugitiveblame",
    "fzf",
    "help",
    "lspinfo",
    "man",
    "qf",
    "startuptime",
  },
  callback = function()
    nmap("q", function()
      utils.cmd("close")
    end, { silent = true, buffer = 0 })
  end,
})
  end,
})
