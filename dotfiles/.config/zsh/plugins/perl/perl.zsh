# Place your plugin content here
source "$ZDOTDIR/zsh-functions.sh"

# Perl
function __load_perl {
    eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
}

zsh_lazy_load perl "__load_perl"
