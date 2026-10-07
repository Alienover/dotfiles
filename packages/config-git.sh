#!/bin/bash

usage="$(basename "$0") [-h] [-n -e -r] [-s] -- Setup the given username and email to the repository locally

OPTIONS:
\t --name, -n \t username
\t --email, e \t email address
\t --repo, -r \t repository location
\t --ssh, -s \t sign commits with an SSH key instead of GPG (optionally --ssh={{ public key path }}, defaults to ~/.ssh/id_ed25519.pub)

GLOBAL OPTIONS:
\t --help, -h \t show help"

USERNAME=""
EMAIL=""
REPO=""
SSH_SIGN=false
SSH_KEY="$HOME/.ssh/id_ed25519.pub"

for arg in "$@"; do
  case $arg in
    -n=*|--name=*)
      USERNAME="${arg#*=}"
      shift
      ;;
    -e=*|--email=*)
      EMAIL="${arg#*=}"
      shift
      ;;
    -r=*|--repo=*)
      REPO="${arg#*=}"
      shift
      ;;
    -s|--ssh)
      SSH_SIGN=true
      shift
      ;;
    -s=*|--ssh=*)
      SSH_SIGN=true
      SSH_KEY="${arg#*=}"
      shift
      ;;
    -h|--help)
      echo "$usage"
      exit 1
      ;;
  esac
done

which git > /dev/null 2>&1 || exit 1

if [ "$SSH_SIGN" = false ]; then
  which gpg > /dev/null 2>&1 || exit 1
fi

if [ -z "$USERNAME" ]; then
  echo "Missing username... please include the username by --name={{ username }}"
  echo "$usage"
  exit 1
fi

if [ -z "$EMAIL" ]; then
  echo "Missing email... please include the email by --email={{ email }}"
  echo "$usage"
  exit 1
fi

if [ -z "$REPO" ]; then
  echo "Missing git repo... please include the git repo directory by --repo={{ repo path }}"
  echo "$usage"
  exit 1
else
  existed=$(git -C $REPO status > /dev/null 2>&1; echo $?)
  if [ "$existed" != 0 ]; then
    echo "The specified directory is not a git repo."
    exit 1
  fi
fi

if [ "$SSH_SIGN" = true ]; then
  SSH_KEY="${SSH_KEY/#\~/$HOME}"
  if [ ! -f "$SSH_KEY" ]; then
    echo "No SSH public key found at [$SSH_KEY]. Please create one or pass its path by --ssh={{ public key path }}"
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
git -C $REPO config user.name "$USERNAME"
git -C $REPO config user.email "$EMAIL"

echo ""
if [ "$SSH_SIGN" = true ]; then
  echo "Setting up SSH signing\n"
  git -C $REPO config gpg.format ssh
  git -C $REPO config user.signingkey "$SSH_KEY"
else
  echo "Setting up GPG\n"
  git -C $REPO config --unset gpg.format > /dev/null 2>&1
  git -C $REPO config user.signingkey $GPG_KEY
fi
git config --global commit.gpgsign true

echo "Git config info"
git -C $REPO config --local -l | grep -E 'user|gpg'

echo ""
echo "Finished $REPO"
