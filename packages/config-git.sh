#!/bin/bash

USERNAME=""
EMAIL=""
REPO=""

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
  esac
done

which git > /dev/null 2>&1 || exit 1

which gpg > /dev/null 2>&1|| exit 1

if [ -z "$USERNAME" ]; then
  echo "Missing username... please include the username by --name={{ username }}"
  exit 1
fi

if [ -z "$EMAIL" ]; then
  echo "Missing email... please include the email by --email={{ email }}"
  exit 1
fi

if [ -z "$REPO" ]; then
  echo "Missing git repo... please include the git repo directory by --repo={{ repo path }}"
  exit 1
else
  existed=$(git -C $REPO status > /dev/null 2>&1; echo $?)
  if [ "$existed" != 0 ]; then
    echo "The specified directory is not a git repo."
    exit 1
  fi
fi

GPG_KEY=`gpg --list-keys | grep "$EMAIL" -C 1 | head -1 | xargs echo`

if [ -z "$GPG_KEY" ]; then
  echo "No GPG Key found for email [$EMAIL]. Please create a GPG key with this email first"
  exit 1
fi

echo "Setting git config for username: [$USERNAME] email: [$EMAIL]\n"

echo "Configuring $REPO\n"

echo "Setting up user info"
git -C $REPO config user.name "$USERNAME"
git -C $REPO config user.email "$EMAIL"

echo ""
echo "Setting up GPG\n"
git -C $REPO config gpg.program $(which gpg)
git -C $REPO config user.signingkey $GPG_KEY
git config --global commit.gpgsign true

echo "Git config info"
git -C $REPO config --local -l | grep 'user'

echo ""
echo "Finished $REPO"
