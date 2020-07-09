
_REPO="$1"
if [[ ! -d "$_REPO" || ! -f "$_REPO/.git/FETCH_HEAD" ]]; then
    echo First Argument must be repo directory
    exit 1
fi
stat -c %Y $_REPO/.git/FETCH_HEAD
