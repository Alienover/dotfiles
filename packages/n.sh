# Install n --- node packages management
curl -L http://git.io/n-install | bash

# Install node
sudo n latest
sudo n stable

# Reload shell
exec $SHELL
