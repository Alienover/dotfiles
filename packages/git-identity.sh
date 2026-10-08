#!/bin/bash

usage="$(basename "$0") [-h] [-n -e -r] [-s] -- Setup the given username and email to the repository locally

OPTIONS:
\t --name, -n \t username (defaults to user.name in the repo's local config)
\t --email, -e \t email address (defaults to user.email in the repo's local config)
\t --repo, -r \t repository location (defaults to the current git repo)
\t --ssh, -s \t sign commits with the given SSH public key (path or key value) instead of GPG

GLOBAL OPTIONS:
\t --help, -h \t show help"

USERNAME=""
EMAIL=""
REPO=""
SSH_KEY=""

while [ $# -gt 0 ]; do
  arg="$1"
  case $arg in
    -n=*|--name=*)
      USERNAME="${arg#*=}"
      ;;
    -e=*|--email=*)
      EMAIL="${arg#*=}"
      ;;
    -r=*|--repo=*)
      REPO="${arg#*=}"
      ;;
    -s|--ssh)
      SSH_KEY="$2"
      shift
      ;;
    -s=*|--ssh=*)
      SSH_KEY="${arg#*=}"
      ;;
    -h|--help)
      echo "$usage"
      exit 1
      ;;
  esac
  shift
done

which git > /dev/null 2>&1 || exit 1

if [ -z "$SSH_KEY" ]; then
  which gpg > /dev/null 2>&1 || exit 1
fi

if [ -z "$REPO" ]; then
  REPO=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -z "$REPO" ]; then
    echo "Missing git repo... please include the git repo directory by --repo={{ repo path }}, or run inside a git repo"
    echo "$usage"
    exit 1
  fi
elif ! git -C "$REPO" rev-parse --git-dir > /dev/null 2>&1; then
  echo "The specified directory is not a git repo."
  exit 1
fi

if [ -z "$USERNAME" ]; then
  USERNAME=$(git -C "$REPO" config --local user.name)
fi

if [ -z "$USERNAME" ]; then
  echo "Missing username... please include the username by --name={{ username }}"
  echo "$usage"
  exit 1
fi

if [ -z "$EMAIL" ]; then
  EMAIL=$(git -C "$REPO" config --local user.email)
fi

if [ -z "$EMAIL" ]; then
  echo "Missing email... please include the email by --email={{ email }}"
  echo "$usage"
  exit 1
fi

if [ -n "$SSH_KEY" ]; then
  KEY_PATH="${SSH_KEY/#\~/$HOME}"
  if [ -f "$KEY_PATH" ]; then
    SSH_KEY="$KEY_PATH"
  elif [[ "$SSH_KEY" != ssh-* && "$SSH_KEY" != key::* ]]; then
    echo "Invalid SSH key [$SSH_KEY]. Please pass a public key path or key value by --ssh={{ key path or key value }}"
    exit 1
  fi
else
  GPG_KEY=`gpg --list-keys | grep "$EMAIL" -C 1 | head -1 | xargs echo`

  if [ -z "$GPG_KEY" ]; then
    echo "No GPG Key found for email [$EMAIL]. Please create a GPG key with this email first"
    exit 1
  fi
fi

echo "Setting git config for username: [$USERNAME] email: [$EMAIL]\n"

echo "Configuring $REPO\n"

echo "Setting up user info"
git -C "$REPO" config user.name "$USERNAME"
git -C "$REPO" config user.email "$EMAIL"

echo ""
if [ -n "$SSH_KEY" ]; then
  echo "Setting up SSH signing\n"
  git -C "$REPO" config gpg.format ssh
  git -C "$REPO" config user.signingkey "$SSH_KEY"
else
  echo "Setting up GPG\n"
  git -C "$REPO" config --unset gpg.format > /dev/null 2>&1
  git -C "$REPO" config user.signingkey $GPG_KEY
fi
git config --global commit.gpgsign true
git config --global tag.gpgsign true

echo "Git config info"
git -C "$REPO" config --local -l | grep -E 'user|gpg'

echo ""
echo "Finished $REPO"
