#! /bin/zsh

function vim {
  NVIM_BIN=`which nvim`

  if [[ $? -ne 0 ]]; then
    \vi $@
    exit 0
  fi

  NVIM_BIN_NIGHTLY="$NVIM_BIN-nightly"
  if [[ -f "$NVIM_BIN_NIGHTLY" ]]; then
    $NVIM_BIN_NIGHTLY $@
  else
    $NVIM_BIN $@
  fi
}
