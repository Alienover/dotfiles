---@type LazySpec
return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonAutoInstall" },
		build = ":MasonUpdate",
		config = function()
			local icons = require("util.icons")
			local sizing = require("util").get_float_win_sizing()

			require("mason").setup({
				ui = {
					width = sizing.width,
					height = sizing.height,
					border = "rounded",
					icons = {
						package_installed = icons.get("extended", "check"),
						package_pending = icons.get("extended", "circle"),
						package_uninstalled = icons.get("extended", "close"),
					},
				},
			})

			-- Auto install the required packages from Mason
			vim.api.nvim_create_user_command("MasonAutoInstall", function()
				local registry = require("mason-registry")
				local const = require("util.constants")

				-- INFO: capture the filetype before crossing the async boundary
				local filetype = vim.bo.filetype

				-- INFO: `get_package` only sees registries that are already
				-- downloaded, so refresh first (mason's own idiom)
				registry.refresh(function()
					for name, opts in pairs(const.ensure_externals) do
						-- INFO: Ignore non-lsp externals
						if opts.external_type ~= const.external_type.lsp then
							goto continue
						end

						-- INFO: Check whether it's enabled and available for the current
						-- filetype. `vim.lsp.config[name]` resolves and caches the config
						-- for enabled names; it is nil for an unknown one, and
						-- `filetypes` being nil means "all filetypes".
						local config = vim.lsp.is_enabled(name) and vim.lsp.config[name] or nil
						if not config or not vim.list_contains(config.filetypes or {}, filetype) then
							goto continue
						end

						-- INFO: Get the mason package and check whether it's installed.
						-- `install` asserts on an in-flight install, so guard that too.
						local ok, pkg = pcall(registry.get_package, opts.mason)
						if not ok or not pkg or pkg:is_installed() or pkg:is_installing() then
							goto continue
						end

						-- INFO: Perform the package installation
						local log_opts = { id = pkg.name }
						vim.notify("Installing " .. pkg.name .. "...", vim.log.levels.INFO, log_opts)

						pkg:install({}, function(success, result)
							if success then
								vim.notify(pkg.name .. " is installed.", vim.log.levels.INFO, log_opts)
							else
								vim.notify(
									("Failed to install %s: %s"):format(pkg.name, tostring(result)),
									vim.log.levels.ERROR,
									log_opts
								)
							end
						end)

						::continue::
					end
				end)
			end, {
				desc = "Auto install the enabled LSP servers",
			})
		end,
	},
}
