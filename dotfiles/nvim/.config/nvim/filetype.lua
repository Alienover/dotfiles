-- Custom filetypes
vim.filetype.add({
	-- Nvim only detects `tmux*.conf`; these are plain `*.tmux` include files
	extension = { tmux = "tmux" },
})
