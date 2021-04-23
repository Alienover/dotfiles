source "$PWD/utils.sh"

PYENV_BIN="$HOME/.pyenv/bin"
PYENV_ALIAS="$PYENV_BIN/pyenv"

log_start "Installing pyenv..."
silent "curl -Ls https://pyenv.run | bash" || log_error
log_success

write_to_zshrc ""
write_to_zshrc "export PATH=\"$PYENV_BIN:\$PATH\""
write_to_zshrc "eval \"\$(pyenv init -)\""
write_to_zshrc "eval \"\$(pyenv virtualenv-init -)\""

# TODO: choose a better version
log_start "install python@2.7.0..."
silent "$PYENV_ALIAS install 2.7.0" || log_error
log_success

log_start "install python@3.7.0..."
silent "$PYENV_ALIAS install 3.7.0" || log_error
silent "$PYENV_ALIAS global 3.7.0" || log_error
log_success

log_start "Installing pyenv-virtualenvwrapper..."
silent "git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git \$($PYENV_ALIAS root)/plugins/pyenv-virtualenvwrapper" || log_error
silent "pyenv virtualenvwrapper" || log_error
log_success
