#! /bin/sh

# @reference
# - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
# - https://tourcoder.com/gpg-on-macos/

# NOTE: This script is about to record the instructions of each step to setup the GPG

brew install gpg pinentry-mac

# Generate GPG key with full instructions
gpg --full-generate-key

# Git setup
# NOTE: remove `--global` when setup for certain repo
git config --global gpg.program $(which gpg)
git config --global user.signingkey <GPG KEY>
git config --global commit.gpgsign true # Auto GPG sign on each commit

# Export the public key, and upload to github on https://github.com/settings/keys
gpg --armor --export <Emai>

###########
#   Q&A  #
##########
# NOTE: Got the following errors when `git commit`
>  error: gpg failed to sign the data
>  fatal: failed to write commit object
## FIX: - Run the following commands
>  echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
>  killall gpg

