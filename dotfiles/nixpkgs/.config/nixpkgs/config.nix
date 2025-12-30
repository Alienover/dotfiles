{
  packageOverrides = pkgs: with pkgs; {
    devPackages = pkgs.buildEnv {
      name = "dev-packages";
      paths = [
        zsh
        neovim
        tmux
        nodejs_24
        fd
        ripgrep
        fzf
        delta
        git
      ];
    };
  };
}
