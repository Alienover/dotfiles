---@type LazySpec
return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonAutoInstall", "MasonPkgToggle", "MasonPkgCleanup" },
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
					local pkg_list = MasonPkgManager:read()
					for _, pkg_name in ipairs(pkg_list) do
						local ok, pkg = pcall(registry.get_package, pkg_name)
						if ok and pkg and not pkg:is_installed() then
							pkg:install()
						end
					end
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
				local registry = require("mason-registry")

				-- Check if package exists in mason registry
				local ok, pkg = pcall(registry.get_package, pkg_name)
				if not ok or not pkg then
					vim.notify("Package not found in Mason registry: " .. pkg_name, vim.log.levels.ERROR)
					return
				end

				-- Toggle the package in enabled list
				local is_enabled = MasonPkgManager:toggle(pkg_name)

				-- If enabled and not installed, install it
				if is_enabled and not pkg:is_installed() then
					vim.notify("Enabling and installing: " .. pkg_name, vim.log.levels.INFO)
					pkg:install()
				else
					vim.notify((is_enabled and "Enabled: " or "Disabled: ") .. pkg_name, vim.log.levels.INFO)
				end
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

			-- Cleanup Mason packages not in the enabled list
			vim.api.nvim_create_user_command("MasonPkgCleanup", function()
				local registry = require("mason-registry")
				local enabled_pkgs = MasonPkgManager:read()

				-- Get all installed packages
				local installed_pkgs = registry.get_installed_packages()
				local to_uninstall = {}

				-- Find packages that are installed but not in enabled list
				for _, pkg in ipairs(installed_pkgs) do
					local pkg_name = pkg.name
					if not vim.tbl_contains(enabled_pkgs, pkg_name) then
						table.insert(to_uninstall, pkg_name)
					end
				end

				if #to_uninstall == 0 then
					vim.notify("No packages to cleanup", vim.log.levels.INFO)
					return
				end

				-- Uninstall packages
				for _, pkg_name in ipairs(to_uninstall) do
					local ok, pkg = pcall(registry.get_package, pkg_name)
					if ok and pkg and pkg:is_installed() then
						vim.notify("Uninstalling: " .. pkg_name, vim.log.levels.INFO)
						pkg:uninstall()
					end
				end

				vim.notify(string.format("Cleanup complete: removed %d package(s)", #to_uninstall), vim.log.levels.INFO)
			end, {})
		end,
	},
}
