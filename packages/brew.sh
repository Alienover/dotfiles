source "$PWD/utils.sh"

# Install from github.com
log_start "Installing homebrew..."
silent "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" || log_error
log_success

# Refer to: https://zhuanlan.zhihu.com/p/111014448

# Install from gitee.com
# Fully install which takes a few minutes
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"

# Simplifily install which only takes a few seconds
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)" speed


# Uninstallation
# macOS
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/HomebrewUninstall.sh)"
