-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

local Utils = require "utils"

return require "packer".startup(
    {
        function(use)
            -- Packer can manage itself
            use {"wbthomason/packer.nvim", opt = true}
            use {
                "vim-scripts/kwbdi.vim",
                opt = true,
                event = "BufEnter"
            }
            use(
                {
                    "folke/which-key.nvim",
                    event = "VimEnter",
                    config = function()
                        require "config/which-key-config"
                    end
                }
            )

            -- Styling
            use {
                "monsonjeremy/onedark.nvim",
                config = function()
                    require "config/onedark-config"
                end
            }

            -- Icons
            use {
                "kyazdani42/nvim-web-devicons",
                module = "nvim-web-devicons",
                config = function()
                    require "nvim-web-devicons".setup({default = true})
                end
            }

            -- Statusline
            use {
                "hoob3rt/lualine.nvim",
                event = "BufReadPre",
                config = function()
                    require "config/lualine-config"
                end
            }
            -- Tabs
            use {
                "akinsho/nvim-bufferline.lua",
                event = "BufReadPre",
                wants = "nvim-web-devicons",
                config = function()
                    require "config/bufferline-config"
                end
            }

            -- Editor
            use "tpope/vim-fugitive"
            use "janko-m/vim-test"

            use "editorconfig/editorconfig-vim"
            use {
                "b3nj5m1n/kommentary",
                opt = true,
                wants = "nvim-ts-context-commentstring",
                keys = {"gc", "gcc"},
                config = function()
                    require "config/kommentary-config"
                end,
                requires = "JoosepAlviste/nvim-ts-context-commentstring"
            }

            use {
                "kevinhwang91/rnvimr",
                run = "make sync",
                config = function()
                    require "config/rnvimr-config"
                end
            }
            use {"nvim-lua/plenary.nvim", module = "plenary"}
            use {"nvim-lua/popup.nvim", module = "popup"}
            -- Diffview
            use {
                "sindrets/diffview.nvim",
                cmd = {"DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles"},
                config = function()
                    require "config/diffview-config"
                end
            }

            use {
                "andymass/vim-matchup",
                event = "CursorMoved"
            }

            use {
                "simrat39/symbols-outline.nvim",
                cmd = {"SymbolsOutline"},
                config = function()
                    require "config/symbol-outline-config"
                end
            }

            -- Fuzzy finder
            use {
                "nvim-telescope/telescope.nvim",
                opt = true,
                config = function()
                    require "config/telescope-config"
                end,
                cmd = {"Telescope"},
                keys = {"<leader><space>"},
                wants = {
                    "popup.nvim",
                    "plenary.nvim",
                    "telescope-fzf-native.nvim"
                },
                requires = {
                    "nvim-lua/popup.nvim",
                    "nvim-lua/plenary.nvim",
                    {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
                }
            }

            -- Snippets
            use {
                "hrsh7th/vim-vsnip",
                opt = true,
                config = function()
                    require "config/vsnip-config"
                end,
                requires = {"hrsh7th/vim-vsnip-integ"}
            }

            -- LSP
            use {
                "neovim/nvim-lspconfig",
                opt = true,
                event = "BufReadPre",
                wants = {"lua-dev.nvim"},
                config = function()
                    require "lsp"
                end,
                requires = {
                    "folke/lua-dev.nvim"
                }
            }
            use {
                "hrsh7th/nvim-compe",
                opt = true,
                event = "InsertEnter",
                config = function()
                    require "config/compe-config"
                end,
                wants = {"vim-vsnip"},
                requires = {
                    "hrsh7th/vim-vsnip",
                    "hrsh7th/vim-vsnip-integ",
                    {
                        "windwp/nvim-autopairs",
                        config = function()
                            require "config/autopairs-config"
                        end
                    }
                }
            }

            -- Frontend
            use {
                "ap/vim-css-color",
                event = "BufReadPre"
            }

            -- JavaScript
            use {
                "mxw/vim-jsx",
                event = "BufReadPre",
                ft = {"javascript.jsx", "javascriptreact", "typescript.jsx", "typescriptreact"}
            }
            use {
                "pangloss/vim-javascript",
                event = "BufReadPre",
                ft = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.jsx"
                }
            }
            use {
                "heavenshell/vim-jsdoc",
                ft = {"javascript", "javascript.jsx", "typescript", "typescript.jsx"},
                event = "BufReadPre",
                run = "make install"
            }

            -- Smooth Scrolling
            use {
                "karb94/neoscroll.nvim",
                keys = {"<C-u>", "<C-d>", "gg", "G"},
                config = function()
                    require "config/neoscroll-config"
                end
            }

            -- Git Gutter
            use {
                "lewis6991/gitsigns.nvim",
                event = "BufReadPre",
                wants = "plenary.nvim",
                requires = {"nvim-lua/plenary.nvim"},
                config = function()
                    require "config/gitsigns-config"
                end
            }

            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                config = function()
                    require "config/treesitter-config"
                end,
                requires = {
                    {"nvim-treesitter/playground", cmd = {"TSHighlightCapturesUnderCursor", "TSPlaygroundToggle"}}
                }
            }
        end,
        config = {
            display = {
                open_fn = function()
                    return require "packer.util".float(
                        Utils.get_float_win_opts(
                            {
                                {border = "single"}
                            }
                        )
                    )
                end
            }
        }
    }
)
