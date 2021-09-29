languages='Golang lua JavaScript TypeScript Python' 
core_utils='xargs find mv sed awk sed'

selected=`echo $languages $core_utils | tr ' ' '\n' | fzf`
echo "Selected:" $selected 
read -p "Query: " query

title=`echo $selected | tr '[:upper:]' '[:lower:]'`

if echo $languages | grep -qso $selected; then
    curl -s cht.sh/$title/`echo $query | tr ' ' '+'` | less 
else
    curl -s cht.sh/$title~$query | less 
fi
