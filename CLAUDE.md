# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS (yabai/skhd/aerospace/borders), Arch Linux (river/foot/wob/kanshi, Wayland), and DevPod containers. There is no build or test suite. Changes are config edits, verified by reloading the tool they belong to.

## Layout and how it gets deployed

- `dotfiles/<pkg>/` holds the GNU Stow packages. The tree inside each package mirrors `$HOME` (for example `dotfiles/nvim/.config/nvim/` → `~/.config/nvim/`). `dotfiles/.stowrc` sets `--target=$HOME`.
- `./setup [pkg ...]` stows the packages you name, or all of them except `devpod` when you name none. Because the files are symlinked, edits to existing files take effect live. Re-run `setup <pkg>` after adding a new package, or after adding files to a `--no-folding` package or to a path stow didn't fold into a directory symlink.
  - `gnupg`, `git`, `ssh`, and `user_scripts` are stowed with `--no-folding`, so per-file symlinks are created and the target directories (`~/.ssh`, `~/.local/bin`, …) stay real. Add any new package that shares a directory with non-repo files to the `case` in `setup`.
  - After stowing, `setup` also adds `~/.gitconfig.common` to the global gitconfig through `include.path`, prepends `Include ~/.ssh/config.d/*` to `~/.ssh/config`, and seeds `~/.gnupg/gpg-agent.conf` from the `.example` file. `**/.gitconfig` is gitignored on purpose, because machine-specific identity lives there. See `user_scripts/.local/bin/git-identity`.
- `devpod-bootstrap` is the DevPod `DOTFILES_SCRIPT`. It stows a subset of packages (`devpod nvim tmux shell user_scripts git`), runs `mise install`, and restores nvim plugins headlessly from `lazy-lock.json`. `install/darwin/install-devpod-config` configures the macOS host to use it.
- `install/{arch,darwin}/` holds one-off OS provisioning scripts and READMEs with manual steps. `packages/` holds the Brewfile, custom Homebrew formulas, and installers for fonts and terminfo.

## Shell startup chain

`~/.zprofile` sets `SYSTEM_OS` and sources `~/.config/shell/profile.<os>`, falling back to `profile.default`. That profile defines the XDG vars, `TERM`, `EDITOR`, and `PATH`, and then sources `~/.zshrc`. `.zshrc` bootstraps zinit, loads `shell/alias.sh` and `shell/colors.sh` (both also shared with the DevPod `.bashrc`), and then sources the local plugins in `~/.config/zsh/plugins/` in a fixed order listed in `.zshrc`. Register any new plugin file in that list. Configs throughout depend on `$XDG_CONFIG_HOME` and friends being set by the profile (tmux `source-file` paths, for example).

## Neovim (`dotfiles/nvim/.config/nvim`)

- lazy.nvim with `defaults.lazy = true`. Each file in `lua/plugins/` returns a `LazySpec` and is auto-imported. Shared helpers (float window sizing, icons, statusline/winbar) live in `lua/util/`.
- `init.lua` loads `config.options` eagerly, then defers `config.keymaps` and the clipboard until `VeryLazy`. `config.autocmds` also waits for `VeryLazy` when nvim starts with no file arguments. It also enables the experimental `vim._core.ui2`, so the config targets a recent nvim nightly or 0.12+.
- LSP servers use the native `lsp/<server>.lua` override files together with `nvim-lspconfig`. Formatting is done by conform.nvim with format-on-save (stylua for Lua, so lua_ls formatting is disabled). Lua is indented with tabs.
- `lazy-lock.json` is committed. Lock bumps go in their own commit, `chore(nvim): lazy-lock update`.

## tmux

`tmux.conf` sources `options.tmux`, `keymaps.tmux`, and `theme.tmux` from `$XDG_CONFIG_HOME/tmux/` and bootstraps TPM through `tpm-bootstrap`. Many `user_scripts` (`tmux-popup`, `tmux-floatx`, `fzf-git-*`) are tmux popup helpers that git aliases in `.gitconfig.common` also call.

## Conventions

- The Catppuccin Mocha theme is used across tools (nvim, kitty, alacritty, bat, btop, tmux, qutebrowser). Keep new configs consistent with it.
- Commits use conventional commits scoped by package, e.g. `feat(devpod): ...`, `fix(nvim): ...`, `refactor(git): ...`.
