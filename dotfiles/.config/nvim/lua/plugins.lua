local utils = require("utils")
local packer = require("utils.packer")
local constants = require("utils.constants")

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  display = {
    open_fn = function()
      return require("packer.util").float(utils.get_float_win_opts({
        border = true,
      }))
    end,
  },
  local_plugins = {
    -- INFO: this is NOT packer functionality!
    ["nvim-gps"] = {
      enabled = true,
      path = constants.local_plugins.gps,
    },
    ["kwbdi.nvim"] = {
      enabled = true,
      path = constants.local_plugins.kwbdi,
    },
    ["lsp-marks.nvim"] = {
      enabled = true,
      path = constants.local_plugins.marks,
    },
    ["fzf-finder.nvim"] = {
      enabled = true,
      path = constants.local_plugins.fzf,
    },
  },
}

local plugins = function(use)
  -- Ignore {{{
  -- use("github/copilot.vim")
  -- }}}

  -- Package management {{{
  use( -- Packer can manage itself
    { "wbthomason/packer.nvim", opt = true }
  )
  -- }}}

  -- Noevim enhancements {{{
  use({ "tweekmonster/startuptime.vim", opt = true, cmd = "StartupTime" })

  use({ -- speed up neovim!
    "nathom/filetype.nvim",
    config = function()
      require("config/filetype-config")
    end,
  })

  use({ -- Fix the CursorHold performance bug
    "antoinemadec/FixCursorHold.nvim",
  })

  use({ "nvim-lua/plenary.nvim" })

  use({ "nvim-lua/popup.nvim", module = "popup" })

  use({
    "kwbdi.nvim",
    cmd = { "KWBufDel" },
    config = function()
      require("kwbdi").setup()
    end,
  })
  -- }}}

  -- Editor {{{
  use({
    "folke/which-key.nvim",
    opt = true,
    keys = { "<space>" },
    cmd = { "WhichKey" },
    config = function()
      require("config/which-key-config")
    end,
  })

  use({ -- Handle `.editorconfig` settings
    "editorconfig/editorconfig-vim",
    opt = true,
    event = "BufEnter",
  })

  use({ -- Files browser
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    event = "VimEnter",
    config = function()
      require("config/telescope-config")
    end,
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
  })

  use({
    "kevinhwang91/rnvimr",
    -- opt = true,
    keys = { "<C-f>" },
    cmd = { "RnvimrToggle" },
    config = function()
      require("config/rnvimr-config")
    end,
  })

  use({
    "numToStr/Comment.nvim",
    opt = true,
    keys = { "gc", "gb", "gcc", "gbc" },
    config = function()
      require("Comment").setup({})
    end,
  })

  use({ -- Smooth Scrolling
    "karb94/neoscroll.nvim",
    opt = true,
    keys = { "<C-u>", "<C-d>", "gg", "G", "zz" },
    config = function()
      require("config/neoscroll-config")
    end,
  })

  use({
    "norcalli/nvim-colorizer.lua",
    opt = true,
    event = "BufReadPre",
    config = function()
      require("config/colorizer-config")
    end,
  })

  use({
    "folke/todo-comments.nvim",
    opt = true,
    event = "BufReadPre",
    cmd = { "TodoQuickFix", "TodoTelescope" },
    config = function()
      require("config/todo-config")
    end,
    requires = "nvim-lua/plenary.nvim",
  })

  use({ -- Snippets
    "L3MON4D3/LuaSnip",
    config = function()
      require("config/luasnip-config")
    end,
  })

  use({ -- Completions
    "hrsh7th/nvim-cmp",
    config = function()
      require("config/cmp-config")
    end,
    requires = {
      -- Sources
      -- { "hrsh7th/cmp-vsnip", opt = true, event = "InsertEnter" },
      { "hrsh7th/cmp-buffer", opt = true, event = "InsertEnter" },
      { "hrsh7th/cmp-emoji", opt = true, event = "InsertEnter" },
      { "hrsh7th/cmp-path", opt = true, event = "InsertEnter" },
      { "hrsh7th/cmp-calc", opt = true, event = "InsertEnter" },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        opt = true,
        event = "InsertEnter",
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "ray-x/cmp-treesitter",
    },
  })

  use({
    "fzf-finder.nvim",
    cmd = { "FZFFiles" },
    config = function()
      require("fzf-finder").setup()
    end,
  })

  -- }}}

  -- Theming {{{
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("config/theme-config")
    end,
  })
  use({ -- Icons
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })
  use({ -- Statusline
    "hoob3rt/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("config/lualine-config")
    end,
    requires = {
      "SmiteshP/nvim-gps",
      { "kyazdani42/nvim-web-devicons", opt = true },
    },
  })
  use({ -- Tabs
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    config = function()
      require("config/bufferline-config")
    end,
  })
  -- }}}

  -- Git {{{
  use({
    "tpope/vim-fugitive",
    opt = true,
    cmd = { "Git", "Gdiff" },
  })
  use({
    "sindrets/diffview.nvim",
    opt = true,
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config/diffview-config")
    end,
  })
  use({ -- Git Gutter
    "lewis6991/gitsigns.nvim",
    opt = true,
    event = "BufReadPre",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config/gitsigns-config")
    end,
  })
  -- }}}

  -- LSP {{{
  use({ "williamboman/nvim-lsp-installer" })

  use({
    "neovim/nvim-lspconfig",
    -- opt = true,
    -- event = "BufReadPre",
    after = "nvim-lsp-installer",
    config = function()
      require("lsp")
    end,
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/nvim-lsp-installer",
      "folke/lua-dev.nvim",
      { "RRethy/vim-illuminate", event = "CursorMoved" },
      {
        -- Replace the original repo for nvim v5.1 compatibility
        -- "glepnir/lspsaga.nvim",
        "tami5/lspsaga.nvim",
        -- branch = "nvim51",
        event = "BufReadPre",
        config = function()
          require("config/saga-config")
        end,
      },
      {
        "folke/lsp-colors.nvim",
        config = function()
          require("lsp-colors").setup({})
        end,
      },
      { -- Provides the `go_def` and `go_back` with marks
        "lsp-marks.nvim",
        config = function()
          require("lsp-marks").setup()
        end,
      },
    },
  })

  use({
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("config/gps-config")
    end,
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("config/treesitter-config")
    end,
    requires = {
      { "andymass/vim-matchup", opt = true, event = "CursorMoved" },
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-refactor",
      {
        "windwp/nvim-autopairs",
        event = "BufReadPre",
        config = function()
          require("config/autopairs-config")
        end,
      },
      {
        "nvim-treesitter/playground",
        cmd = {
          "TSHighlightCapturesUnderCursor",
          "TSPlaygroundToggle",
        },
      },
    },
  })
  -- }}}

  -- Focus {{{
  use({
    "folke/zen-mode.nvim",
    opt = true,
    cmd = "ZenMode",
    requires = { "folke/twilight.nvim" },
    config = function()
      require("zen-mode").setup({
        plugins = {
          gitsigns = true,
          tmux = true,
          kitty = { enabled = false, font = "+2" },
        },
      })
    end,
  })
  -- }}}

  -- Frontend {{{
  -- JavaScript
  use({
    "heavenshell/vim-jsdoc",
    opt = true,
    cmd = { "JsDoc", "JsDocFormat" },
    ft = {
      "javascript",
      "javascript.jsx",
      "typescript",
      "typescript.jsx",
    },
    run = "make install",
  })
  use({
    "janko-m/vim-test",
    opt = true,
    cmd = { "TestFile", "TestNearest" },
  })
  -- }}}
end

packer.setup(plugins, config)
