#! /bin/sh

FONT_NAME="VictorMono"

download() {
  local url=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "download_url" | grep "zip" | grep "$FONT_NAME" | cut -d'"' -f 4)
  echo $url

  wget -q --show-progress --progress=bar --directory-prefix="/Users/jiarong/Downloads" "$url"
}

download
