return {
	-- add blink.compat
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"saghen/blink.compat",
			{
				"MattiasMTS/cmp-dbee",
				ft = "sql", -- optional but good to have
				opts = {}, -- needed
			},
		},

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "none",
				["<Tab>"] = { "select_and_accept", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-p>"] = { "show", "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
			},

			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				-- Show documentation when selecting a completion item
				documentation = { auto_show = true, auto_show_delay_ms = 500 },

				menu = {
					draw = {
						columns = { { "label" }, { "kind_icon" }, { "source_name" } },
					},
				},

				ghost_text = { enabled = true, show_without_menu = true },
			},

			cmdline = {
				enabled = true,
				keymap = { preset = "inherit" },

				completion = {
					menu = {
						auto_show = false,
						draw = {
							columns = { { "label", "label_description", gap = 1 } },
						},
					},
					ghost_text = { enabled = true },
				},

				---@diagnostic disable-next-line: assign-type-mismatch
				sources = function()
					local type = vim.fn.getcmdtype()
					-- Search forward and backward
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					-- Commands
					if type == ":" or type == "@" then
						return { "cmdline" }
					end
					return {}
				end,
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			snippets = { preset = "luasnip" },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = { sql = { "dbee", "buffer" } },
				providers = {
					-- Refer to https://github.com/MattiasMTS/cmp-dbee/issues/29#issue-2783603343
					dbee = { name = "DB", module = "blink.compat.source", opts = { cmp_name = "cmp-dbee" } },
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
