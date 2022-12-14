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
      enable = false,
      path = constants.local_plugins.lspsaga,
    },
    ["nvim-gps"] = {
      enable = false,
      path = constants.local_plugins.gps,
    },
    ["kwbdi.nvim"] = {
      enable = true,
      path = constants.local_plugins.kwbdi,
    },
    ["lsp-marks.nvim"] = {
      enable = true,
      path = constants.local_plugins.marks,
    },
    ["fzf-finder.nvim"] = {
      enable = true,
      path = constants.local_plugins.fzf,
    },
    ["winbar.nvim"] = {
      enable = true,
      path = constants.local_plugins.winbar,
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
      require("config.filetype-config")
    end,
  })

  use({ "nvim-lua/plenary.nvim" })

  use({
    "kwbdi.nvim",
    cmd = { "KWBufDel" },
    config = function()
      require("kwbdi").setup()
    end,
  })

  use({
    "max397574/better-escape.nvim",
    config = function()
      require("config.escape-config")
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
      require("config.which-key-config")
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
      require("config.telescope-config")
    end,
    requires = {
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
      require("config.rnvimr-config")
    end,
  })

  use({
    "numToStr/Comment.nvim",
    opt = true,
    keys = { "gc", "gb", "gcc", "gbc" },
    config = function()
      require("config.comment-config")
    end,
  })

  use({ -- Smooth Scrolling
    "karb94/neoscroll.nvim",
    opt = true,
    keys = { "<C-u>", "<C-d>", "gg", "G", "zz" },
    config = function()
      require("config.neoscroll-config")
    end,
  })

  use({
    "norcalli/nvim-colorizer.lua",
    opt = true,
    event = "BufReadPre",
    config = function()
      require("config.colorizer-config")
    end,
  })

  use({
    "folke/todo-comments.nvim",
    opt = true,
    event = "BufReadPre",
    cmd = { "TodoQuickFix", "TodoTelescope" },
    config = function()
      require("config.todo-config")
    end,
    requires = "nvim-lua/plenary.nvim",
  })

  use({ -- Snippets
    "L3MON4D3/LuaSnip",
    config = function()
      require("config.luasnip-config")
    end,
  })

  use({ -- Completions
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.cmp-config")
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
      { "hrsh7th/cmp-nvim-lua", ft = "lua" },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
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

  use({
    "janko-m/vim-test",
    opt = true,
    cmd = { "TestFile", "TestNearest" },
  })

  use({
    "NTBBloodbath/rest.nvim",
    ft = { "http" },
    cmd = { "RestExecute" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.rest-config")
    end,
  })

  use({
    "winbar.nvim",
    -- disable = true,
    event = { "VimEnter" },
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  use({
    "RRethy/vim-illuminate",
    event = "CursorMoved",
    config = function()
      require("config.illuminate-config")
    end,
  })

  use({
    "folke/noice.nvim",
    config = function()
      require("config.noice-config")
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  })
  -- }}}

  -- Theming {{{
  use({
    "folke/tokyonight.nvim",
    config = function()
      require("config.theme-config")
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
      require("config.lualine-config")
    end,
    requires = {
      { "kyazdani42/nvim-web-devicons", opt = true },
    },
  })
  use({ -- Tabs
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    config = function()
      require("config.bufferline-config")
    end,
  })
  -- }}}

  -- Git {{{
  use({
    "dinhhuy258/git.nvim",
    cmd = { "GitBlame" },
    config = function()
      require("git").setup()
    end,
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
      require("config.diffview-config")
    end,
  })
  use({ -- Git Gutter
    "lewis6991/gitsigns.nvim",
    opt = true,
    cmd = { "Gitsigns" },
    event = "BufReadPost",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns-config")
    end,
  })
  -- }}}

  -- LSP {{{
  use({
    "williamboman/mason.nvim",
    requires = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("config.mason-config")
    end,
  })

  use({
    "neovim/nvim-lspconfig",
    -- opt = true,
    -- event = "BufReadPre",
    after = "mason.nvim",
    config = function()
      require("lsp")
    end,
    requires = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/neodev.nvim",
      { "RRethy/vim-illuminate", event = "CursorMoved" },
      {
        "glepnir/lspsaga.nvim",
        event = "BufReadPre",
        config = function()
          require("config.saga-config")
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
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("config.treesitter-config")
    end,
    requires = {
      { "andymass/vim-matchup", opt = true, event = "CursorMoved" },
      "windwp/nvim-ts-autotag",
      {
        "windwp/nvim-autopairs",
        event = "BufReadPre",
        config = function()
          require("config.autopairs-config")
        end,
      },
      {
        "nvim-treesitter/playground",
        cmd = {
          "TSHighlightCapturesUnderCursor",
          "TSPlaygroundToggle",
        },
      },
      {
        -- Disable it due to no usage
        disable = true,
        "nvim-treesitter/nvim-treesitter-refactor",
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
end

packer.setup(plugins, config)
