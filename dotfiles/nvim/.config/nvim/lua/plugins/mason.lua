---@type LazySpec
return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonAutoInstall" },
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

			-- Auto install the required packages from Mason
			vim.api.nvim_create_user_command("MasonAutoInstall", function()
				local registry = require("mason-registry")

				for _, client in ipairs(vim.lsp.get_clients()) do
					local ok, pkg = pcall(registry.get_package, client.name)

					if ok and pkg and not pkg:is_installed() then
						pkg:install()
					end
				end
			end, {
				desc = "Auto install the enabled LSP servers",
			})
		end,
	},
}
