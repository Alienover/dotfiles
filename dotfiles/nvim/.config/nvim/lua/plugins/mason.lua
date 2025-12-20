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
				local constants = require("custom.constants")

				local function ensure_installed()
					local disabled_pkgs = MasonPkgManager:read()

					-- Install all packages from ensure_externals that are not disabled
					for _, external_opts in pairs(constants.ensure_externals) do
						local mason_pkg = external_opts.mason
						if mason_pkg and not vim.tbl_contains(disabled_pkgs, mason_pkg) then
							local ok, pkg = pcall(registry.get_package, mason_pkg)
							if ok and pkg and not pkg:is_installed() then
								pkg:install()
							end
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
				local registry = require("mason-registry")
				local pkg_names = opts.fargs

				if #pkg_names == 0 then
					vim.notify("No package names provided", vim.log.levels.ERROR)
					return
				end

				-- Phase 1: Validation - collect valid packages
				local valid_packages = {}
				local valid_pkg_objects = {}

				for _, pkg_name in ipairs(pkg_names) do
					local ok, pkg = pcall(registry.get_package, pkg_name)
					if not ok or not pkg then
						vim.notify("Package not found in Mason registry: " .. pkg_name, vim.log.levels.ERROR)
					else
						table.insert(valid_packages, pkg_name)
						valid_pkg_objects[pkg_name] = pkg
					end
				end

				if #valid_packages == 0 then
					return
				end

				-- Phase 2: Batch Toggle - single file I/O operation
				local toggle_results = MasonPkgManager:toggle(valid_packages)

				-- Phase 3: Process Results - install/uninstall based on toggle state
				for _, pkg_name in ipairs(valid_packages) do
					local is_disabled = toggle_results[pkg_name]
					local pkg = valid_pkg_objects[pkg_name]

					if is_disabled then
						-- Package was just disabled, uninstall it
						if pkg:is_installed() then
							vim.notify("Disabling and uninstalling: " .. pkg_name, vim.log.levels.INFO)
							pkg:uninstall()
						else
							vim.notify("Disabled: " .. pkg_name, vim.log.levels.INFO)
						end
					else
						-- Package was just enabled (removed from disabled list), install it
						if not pkg:is_installed() then
							vim.notify("Enabling and installing: " .. pkg_name, vim.log.levels.INFO)
							pkg:install()
						else
							vim.notify("Enabled: " .. pkg_name, vim.log.levels.INFO)
						end
					end
				end
			end, {
				nargs = "+",
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

			-- Cleanup Mason packages in the disabled list
			vim.api.nvim_create_user_command("MasonPkgCleanup", function()
				local registry = require("mason-registry")
				local disabled_pkgs = MasonPkgManager:read()

				-- Get all installed packages
				local installed_pkgs = registry.get_installed_packages()
				local to_uninstall = {}

				-- Find packages that are installed and in disabled list
				for _, pkg in ipairs(installed_pkgs) do
					local pkg_name = pkg.name
					if vim.tbl_contains(disabled_pkgs, pkg_name) then
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
