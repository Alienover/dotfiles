#! /usr/bin/env zsh

typeset -g zsh_plugins

function __error() {
  local msg="$1"
  >&2 printf "[%s][ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$msg"
}

# Function to source files if they exist
function zsh_add_file() {
  local dir=${2:-$XDG_CONFIG_HOME/zsh}
  local file="$dir/$1"

  if [ -f "$file" ]; then
    zinit is-snippet for "$file"
  else
    __error "Couldn't find $file"
    return 1
  fi
}

function zsh_add_custom_plugin() {
  local prefix="plugins/$1/$1"
  zsh_add_file "$prefix.zsh" || \
    zsh_add_file "$prefix.plugin.zsh"

  return $?
}

function zsh_lazy_load() {
  local cmd=$1
  local args=${@:2}

  local placeholder="
  function $cmd {
    unfunction \$0
    $args
    \$0 \$@
  }
  "

  eval "$placeholder"
}

function zsh_init() {
  for plugin in $zsh_plugins;
  do zsh_add_custom_plugin "$plugin" || zinit light "$plugin"
  done
}
