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
    ["lspsaga.nvim"] = {
      enabled = false,
      path = constants.custom_plugins.lspsaga,
    },
    ["nvim-lsp-installer"] = {
      enabled = false,
      path = constants.custom_plugins.lspinstaller,
    },
  },
}

local plugins = function(use)
  -- Packer can manage itself
  use({ "wbthomason/packer.nvim", opt = true })
  use({ "tweekmonster/startuptime.vim", opt = true, cmd = "StartupTime" })

  -- speed up neovim!
  use({
    "nathom/filetype.nvim",
    config = function()
      require("config/filetype-config")
    end,
  })

  -- use("github/copilot.vim")

  -- Fix the CursorHold performance bug
  use("antoinemadec/FixCursorHold.nvim")

  use({
    "folke/which-key.nvim",
    opt = true,
    keys = { "<space>" },
    cmd = { "WhichKey" },
    config = function()
      require("config/which-key-config")
    end,
  })

  -- Styling
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("config/theme-config")
    end,
  })

  -- Icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })

  -- Statusline
  use({
    "hoob3rt/lualine.nvim",
    event = "BufReadPre",
    config = function()
      require("config/lualine-config")
    end,
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  -- Tabs
  use({
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    config = function()
      require("config/bufferline-config")
    end,
  })

  -- Editor
  use({
    "tpope/vim-fugitive",
    opt = true,
    cmd = { "Git", "Gdiff" },
  })
  use({
    "janko-m/vim-test",
    opt = true,
    cmd = { "TestFile", "TestNearest" },
  })

  use({
    "editorconfig/editorconfig-vim",
    opt = true,
    event = "BufEnter",
  })

  use({
    "numToStr/Comment.nvim",
    opt = true,
    keys = { "gc", "gb", "gcc", "gbc" },
    config = function()
      require("Comment").setup({})
    end,
  })

  use({ "nvim-lua/plenary.nvim", module = "plenary" })
  use({ "nvim-lua/popup.nvim", module = "popup" })

  -- Diffview
  use({
    "sindrets/diffview.nvim",
    opt = true,
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config/diffview-config")
    end,
  })

  use({
    "andymass/vim-matchup",
    opt = true,
    event = "CursorMoved",
  })

  use({
    "simrat39/symbols-outline.nvim",
    opt = true,
    cmd = { "SymbolsOutline" },
    config = function()
      require("config/symbol-outline-config")
    end,
  })

  -- Files browser
  use({
    "nvim-telescope/telescope.nvim",
    opt = true,
    config = function()
      require("config/telescope-config")
    end,
    cmd = { "Telescope" },
    keys = { "<leader><space>" },
    wants = {
      "popup.nvim",
      "plenary.nvim",
      "telescope-fzf-native.nvim",
    },
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
  })

  use({
    "kevinhwang91/rnvimr",
    opt = true,
    keys = { "<C-f>" },
    cmd = "RnvimrToggle",
    config = function()
      require("config/rnvimr-config")
    end,
  })

  -- LSP
  use({ "williamboman/nvim-lsp-installer" })
  use({
    "neovim/nvim-lspconfig",
    -- opt = true,
    -- event = "BufReadPre",
    wants = {
      "lua-dev.nvim",
      "lsp-colors.nvim",
      "null-ls.nvim",
    },
    config = function()
      require("lsp")
    end,
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/nvim-lsp-installer",
      "folke/lua-dev.nvim",
      {
        -- Replace the original repo for nvim v5.1 compatibility
        -- "glepnir/lspsaga.nvim",
        "tami5/lspsaga.nvim",
        -- branch = "nvim51",
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
    },
  })

  -- Snippets
  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("config/luasnip-config")
    end,
  })

  use({
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
      -- Icons
      "onsails/lspkind-nvim",
    },
  })

  -- Frontend

  use({
    "norcalli/nvim-colorizer.lua",
    opt = true,
    event = "BufReadPre",
    config = function()
      require("config/colorizer-config")
    end,
  })

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

  -- Smooth Scrolling
  use({
    "karb94/neoscroll.nvim",
    opt = true,
    keys = { "<C-u>", "<C-d>", "gg", "G", "zz" },
    config = function()
      require("config/neoscroll-config")
    end,
  })

  -- Git Gutter
  use({
    "lewis6991/gitsigns.nvim",
    opt = true,
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config/gitsigns-config")
    end,
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("config/treesitter-config")
    end,
    requires = {
      "andymass/vim-matchup",
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

  use({
    "folke/zen-mode.nvim",
    opt = true,
    cmd = "ZenMode",
    wants = "twilight.nvim",
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
end

packer.setup(plugins, config)
