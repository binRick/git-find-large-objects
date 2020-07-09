#!/bin/bash -e
EXECUTE_RM_CMD="${EXECUTE_RM_CMD:-1}"
FILES_TO_DELETE="$@"

setup(){
    execution_dir="$(realpath "$(pwd)")"
    base_dir="$( cd "$( dirname "$(realpath "${BASH_SOURCE[0]}")" )" && pwd )"
    source $base_dir/.ansi.sh
    source $base_dir/constants.sh
    source $base_dir/utils.sh
    STARTED_TS=$(_ts)
}


rm_file(){
    ansi --yellow --underline "Deleting Files '$FILES_TO_DELETE' from GIT Objects...."
    cmd="command git filter-branch -f --tree-filter \"command rm -f $FILES_TO_DELETE\" -- --all"
    [[ "$EXECUTE_RM_CMD" == "1" ]] && eval $cmd && return
    ansi --cyan --underline --bg-black "$cmd"
    
}

setup
time rm_file
