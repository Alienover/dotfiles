-- Reference
-- https://github.com/nvim-telescope/telescope.nvim
local telescope = require("telescope")
local ts_actions = require("telescope.actions")

---@type function
---@param method string
local undo = function(method)
  local undo_actions = vim.F.npcall(require, "telescope-undo.actions")
  if undo_actions then
    return undo_actions[method]
  end
end

---@type function
---@param method string
local file_browser = function(method)
  local fb_actions = vim.F.npcall(function()
    return require("telescope").extensions.file_browser.actions
  end, nil)

  if fb_actions then
    return fb_actions[method]
  end
end

telescope.setup({
  defaults = {
    selection_caret = "  ",
    entry_prefix = "  ",

    layout_config = {
      width = 0.5,
      height = 0.5,
    },
    prompt_prefix = " 🌈 ",
    mappings = {
      i = {
        ["<C-j>"] = ts_actions.move_selection_next,
        ["<C-k>"] = ts_actions.move_selection_previous,
        ["<Esc>"] = ts_actions.close,
      },
      n = {
        q = ts_actions.close,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    undo = {
      mappings = {
        i = {
          ["<cr>"] = undo("restore"),
        },
      },
    },
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      hide_parent_dir = true,
      grouped = true,
      initial_mode = "normal",
      respect_gitignore = false,

      use_ui_input = true,

      follow_symlinks = true,

      mappings = {
        ["i"] = {
          -- INFO: Disable all the keymappings in insert mode
        },
        ["n"] = {
          ["d"] = false, -- fb_actions.remove, use "dd" instead
          ["c"] = false, -- fb_actions.create, use "n" instead
          ["g"] = false, -- fb_actions.goto_parent_dir, use "g" instead
          ["m"] = false, -- fb_actions.move, use "p" instead
          ["f"] = false, -- fb_actions.toggle_browser, deprecated
          ["s"] = false, -- fb_actions.toggle_all, use "S" instead
          ["t"] = false, -- fb_actions.change_cwd, use "<C-t>" instead
          ["w"] = false, -- fb_actions.goto_cwd, use "<C-w>" instead
          ["p"] = file_browser("move"),
          ["q"] = ts_actions.close,
          ["h"] = file_browser("goto_parent_dir"),
          ["l"] = ts_actions.select_default,
          ["n"] = file_browser("create"),
          ["dd"] = file_browser("remove"),
          ["g."] = file_browser("toggle_hidden"),
          -- Select all
          ["<C-a>"] = file_browser("toggle_all"),
          ["<C-t>"] = ts_actions.select_tab,
          ["<C-w>"] = file_browser("goto_cwd"),
          ["<C-k>"] = false,
          ["<bs>"] = file_browser("backspace"),
          ["/"] = function()
            vim.cmd("startinsert!")
          end,
        },
      },
    },
  },
})

local extensions = { "fzf", "undo", "noice", "file_browser", "rest" }

for _, ext in ipairs(extensions) do
  telescope.load_extension(ext)
end
