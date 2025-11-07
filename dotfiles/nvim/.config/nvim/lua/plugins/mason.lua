---@type LazySpec
return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonAutoInstall", "MasonPkgToggle" },
		build = ":MasonUpdate",
		config = function()
			local icons = require("custom.icons")
			local sizing = require("custom.utils").get_float_win_sizing()

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

			local MasonPkgManager = require("custom.mason_pkgs")

			-- Auto install the required packages from Mason
			vim.api.nvim_create_user_command("MasonAutoInstall", function()
				local registry = require("mason-registry")

				local function ensure_installed()
					MasonPkgManager:read(function(pkg_list)
						for _, pkg_name in ipairs(pkg_list) do
							local ok, pkg = pcall(registry.get_package, pkg_name)
							if ok and pkg and not pkg:is_installed() then
								pkg:install()
							end
						end
					end)
				end

				if registry.refresh then
					registry.refresh(ensure_installed)
				else
					ensure_installed()
				end
			end, {})

			-- Toggle Mason package enabled state
			vim.api.nvim_create_user_command("MasonPkgToggle", function(opts)
				local pkg_name = opts.args
				MasonPkgManager:toggle(pkg_name, function(is_enabled)
					vim.notify((is_enabled and "Enabled: " or "Disabled: ") .. pkg_name, vim.log.levels.INFO)
				end)
			end, {
				nargs = 1,
				complete = function()
					local mason_pkgs = {}
					for _, external_opts in pairs(require("custom.constants").ensure_externals) do
						local mason = external_opts.mason or ""
						if mason ~= "" then
							table.insert(mason_pkgs, mason)
						end
					end
					table.sort(mason_pkgs)
					return mason_pkgs
				end,
			})
		end,
	},
}
