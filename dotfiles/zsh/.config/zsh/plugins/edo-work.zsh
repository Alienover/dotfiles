# edo-work — Auto-generate lowercase `cd` aliases for each top-level repo under
# ~/Documents/dev so `myrepo` jumps straight into ~/Documents/dev/MyRepo.

function __init_work {
  local repos_root="$HOME/Documents/dev"

  # Alias all the sub-folders
  if [ -d $repos_root ]; then
    eval "$(ls $repos_root | grep -v share | awk -v dir=$repos_root '{print "alias " tolower($0)  "=\"cd " dir "/" $0 "\""}')"
  fi

  unfunction __init_work
}

__init_work
