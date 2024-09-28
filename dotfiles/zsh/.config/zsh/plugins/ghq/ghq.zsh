#! /bin/env zsh

ghq () {
  if [ "$1" = look -a -n "$2" ]; then
    local repos=($(command ghq list -p "$2"))
    case ${#repos[@]} in
      0)
        echo 'No repo found.'
        return 1
        ;;
      1)
        cd "${repos[1]}"
        return
        ;;
      *)
        local PS3="Select repo: "
        select reponame in ${repos[@]}; do
          cd "${reponame}"
          return
        done
    esac
  elif [ "$1" = get -a -n "$2" ]; then
    command ghq "$@"
    cd $(command ghq list -e -p "$2")
    return
  fi
  command ghq "$@"
}
