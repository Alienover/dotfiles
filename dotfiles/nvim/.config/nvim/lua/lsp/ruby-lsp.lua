return {
	cmd = { vim.fs.normalize(vim.fs.joinpath(os.getenv("ASDF_DATA_DIR") or "~/.asdf", "/shims/ruby-lsp")) },
}
