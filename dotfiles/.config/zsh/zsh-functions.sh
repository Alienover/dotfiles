#! /usr/bin/env zsh

__PLUGIN_FOLDER="$HOME/.zsh_plugins"

# Function to source files if they exist
function zsh_add_file() {
  local dir=${2:-$ZDOTDIR}
  local file="$dir/$1"

  if [ -f "$file" ]; then
    source "$file"
  else
    echo "$file not found"
  fi
}

function zsh_add_plugin() {
  local name=$(echo "$1" | cut -d "/" -f 2)
  local plugin_path="$__PLUGIN_FOLDER/$name"
  if [ ! -d "$plugin_path" ]; then
    # Download the plugin automatically
    git clone "https://github.com/$1.git" "$plugin_path"
  fi

  zsh_add_file "$name.plugin.zsh" $plugin_path || \
    zsh_add_file "$name.zsh" $plugin_path
}


function zsh_add_custom_plugin() {
  zsh_add_file "plugins/$1/$1.plugin.zsh" || \
    zsh_add_file "plugins/$1/$1.zsh"
}

function zsh_add_theme() {
  setopt prompt_subst

  zsh_add_file "themes/$1.zsh-theme"
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

function zsh_lazy_load_completions() {
  local cmd=$1
  local args=${@:2}
  local comp="comp_$cmd"

  eval "
  function $comp {
    compdef -d $cmd

    $args
  }
  "

  compdef $comp $cmd
}


function zsh_update_plugin() {
  local name=$(echo "${1:-all}" | cut -d "/" -f 2)

  if [ $name = 'all' ]; then
    for plugin in $(ls $__PLUGIN_FOLDER); do
      zsh_update_plugin $plugin
    done
  else
    local plugin_path="$__PLUGIN_FOLDER/$name"

    if [ -d "$plugin_path" ]; then
      echo "Updating plugin \"$name\"..."
      # pull updates
      git -C $plugin_path pull
    else
      echo "Couldn't find plugin \"$name\""
    fi
  fi
}

