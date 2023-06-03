local utils = require("utils")
local consts = require("utils.constants")

local nmap, tmap, expand = utils.nmap, utils.tmap, utils.expand

local groups = {
  filetype = vim.api.nvim_create_augroup("FT", { clear = true }),
  folding = vim.api.nvim_create_augroup("Folding", { clear = true }),
  terminal = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  directory = vim.api.nvim_create_augroup("Directory", { clear = true }),
}

vim.api.nvim_create_autocmd("TermEnter", {
  desc = "Remove the editor styling and define keymaps on entering terminal",

  group = groups.terminal,
  callback = function()
    local excluded_filetypes = { "rnvimr", "fzf", "LspsagaRename" }
    local bufnr = vim.api.nvim_get_current_buf()
    local curr_ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if vim.tbl_contains(excluded_filetypes, curr_ft) then
      return
    end

    utils.cmd.setlocal("nocursorline nonumber norelativenumber")
    -- Set darker background color
    -- utils.cmd("hi TerminalBG guibg=" .. constants.colors.BLACK)
    -- utils.cmd("set winhighlight=Normal:TerminalBG")

    vim.wo.statuscolumn = ""

    -- Keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    tmap("<ESC>", "<C-\\><C-n>", opts)
    tmap("jk", "<C-\\><C-n>", opts)
    tmap("<c-w>h", "<C-\\><C-n><C-w>h", opts)
    tmap("<c-w>j", "<C-\\><C-n><C-w>j", opts)
    tmap("<c-w>k", "<C-\\><C-n><C-w>k", opts)
    tmap("<c-w>l", "<C-\\><C-n><C-w>l", opts)
  end,
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
  pattern = consts.special_filetypes.close_by_q,
  callback = function()
    nmap("q", function()
      utils.cmd("close")
    end, { silent = true, buffer = 0 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Don't expand tab",

  group = groups.filetype,
  pattern = { "make" },
  callback = function()
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open Ranger once the current buffer is a directory",

  group = groups.directory,
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.fn.isdirectory(expand("%")) == 1 then
      vim.cmd.RnvimrToggle()

      vim.g.__RNVIMR_autocmd_id = vim.api.nvim_create_autocmd("TermLeave", {
        callback = function()
          local autocmd_id = vim.g.__RNVIMR_autocmd_id
          if autocmd_id ~= nil then
            vim.api.nvim_del_autocmd(vim.g.__RNVIMR_autocmd_id)
          end

          if bufnr ~= nil then
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd.KWBufDel("force")
            end)
          end
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Settings for norg files",

  group = groups.filetype,
  pattern = { "norg" },
  callback = function()
    vim.wo.conceallevel = 2
  end,
})
