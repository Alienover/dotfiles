# Function to source files if they exist
function zsh_add_file() {
    local file="$ZDOTDIR/$1"
    if [ -f "$file" ]; then
	source "$file"
    else
	echo "$file not found"
    fi
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo "$1" | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
        # For plugins
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
	if [[ $2 == false ]]; then
	    return 0
	else
	    # Download the plugin automatically
	    git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
	fi
    fi
}

function zsh_add_custom_plugin() {
    zsh_add_plugin "custom/$1" false
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
