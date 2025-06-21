function __init_work {
  local repos_root="${$(git config ghq.root)/#\~/$HOME}"

  eval "$(\
    find "$repos_root/github.com/"{Yipit,agent8} -type d -maxdepth 1 -mindepth 1 2>/dev/null | \
    awk -F/ '{print "alias " tolower($NF)  "=\"cd " $0 "\""}' \
  )"
}

__init_work
