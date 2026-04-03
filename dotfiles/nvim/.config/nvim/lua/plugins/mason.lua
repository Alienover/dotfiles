---@type LazySpec
return {
	{
		"williamboman/mason.nvim",
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

				for name, opts in pairs(const.ensure_externals) do
					-- INFO: Ignore non-lsp externals
					if opts.external_type ~= const.external_type.lsp then
						goto continue
					end

					-- INFO: Check whether it's available for current filetype
					local config = vim.lsp._enabled_configs[name]
					if not vim.list_contains(config.resolved_config.filetypes, vim.bo.filetype) then
						goto continue
					end

					-- INFO: Get the mason package and check whether it's installed
					local ok, pkg = pcall(registry.get_package, opts.mason)
					if not ok or not pkg or pkg:is_installed() then
						goto continue
					end

					-- INFO: Perform the package installation
					local log_opts = { id = pkg.name }
					vim.notify("Installing " .. pkg.name .. "...", vim.log.levels.INFO, log_opts)

					pkg:install({}, function(success)
						if success then
							vim.notify(pkg.name .. " is installed.", vim.log.levels.INFO, log_opts)
						else
							vim.notify("Failed to install " .. pkg.name, vim.log.levels.ERROR, log_opts)
						end
					end)

					::continue::
				end
			end, {
				desc = "Auto install the enabled LSP servers",
			})
		end,
	},
}
