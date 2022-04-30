#! /bin/bash
cd /tmp

url=`curl https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest | grep 'download' | grep 'macos' | cut -d'"' -f 4`

if [ $url != "" ]; then
    filename=`echo $url | cut -d'/' -f 9`
    echo $filename
    /opt/homebrew/bin/proxychains4 wget $url
    unzip $filename
    rm -rf $filename

    chmod +x stylua
    mv stylua /usr/local/bin
else
    echo "stylua not found from repo"
fi
