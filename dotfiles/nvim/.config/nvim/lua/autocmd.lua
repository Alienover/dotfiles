local utils = require("utils")
local icons = require("utils.icons")
local consts = require("utils.constants")

local nmap = utils.nmap

local groups = {
  terminal = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  filetype = vim.api.nvim_create_augroup("FT", { clear = true }),
  linting = vim.api.nvim_create_augroup("Linting", { clear = true }),
  recording = vim.api.nvim_create_augroup("Recording", { clear = true }),
}

-- FIXME: need to find a way to set the filetype
-- using `pattern` in vim.filetype.add
vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Set filetype to terminal",
  group = groups.terminal,

  command = "set filetype=terminal",
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

vim.api.nvim_create_autocmd("RecordingEnter", {
  desc = "Notify when recording starts",
  group = groups.recording,

  callback = function()
    local reg = vim.fn.reg_recording()

    if reg ~= "" then
      vim.g.recording_notify_id = vim.notify(
        string.format("Recording @%s...", reg),
        vim.log.levels.INFO,
        {
          title = " Marco",
          icon = icons.get("extended", "recording"),
          replace = vim.g.recording_notify_id,
          keep = function()
            return vim.fn.reg_recording() ~= ""
          end,
        }
      )
    end
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  desc = "Close notify when recording leaves",
  group = groups.recording,

  callback = function()
    local last_id = vim.g.recording_notify_id

    if last_id then
      vim.notify("Recording stopped", vim.log.levels.INFO, {
        title = " Marco",
        icon = icons.get("extended", "recording"),
        timeout = 100,
        replace = last_id,
      })
    end

    vim.g.recording_notify_id = nil
  end,
})
