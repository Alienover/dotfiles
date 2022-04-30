local terminalGroup = vim.api.nvim_create_augroup("Terminal", { clear = true })
local diffGroup = vim.api.nvim_create_augroup("Diff", { clear = true })
local quitGroup = vim.api.nvim_create_augroup("Quit", { clear = true })

if vim.v.progname == "nvim" then
  vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Remove the editor styling for terminal",

    command = "setlocal nonumber norelativenumber",
    group = terminalGroup,
  })
end

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

  group = quitGroup,
  pattern = { "help", "startuptime", "qf", "lspinfo", "fugitiveblame", "man" },
  callback = function()
    vim.keymap.set("n", "q", function()
      vim.cmd("close")
    end, { silent = true })
  end,
})
