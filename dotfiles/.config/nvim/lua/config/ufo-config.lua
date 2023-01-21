local consts = require("utils.constants")

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local foldedLines = endLnum - lnum
  local suffix = ("  %s  %s %s"):format(
    consts.icons.ui.EllipsisH,
    foldedLines,
    "line" .. (foldedLines > 1 and "s" or "")
  )

  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "Italic" })
  return newVirtText
end

require("ufo").setup({
  fold_virt_text_handler = handler,
  -- @param {number} bufnr
  -- @param {string} filetype
  -- @param {any} buftype
  provider_selector = function()
    return { "treesitter", "indent" }
  end,
  preview = {
    win_config = {
      border = { "", "─", "", "", "", "─", "", "" },
      winblend = 0,
    },
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>",
    },
  },
})
