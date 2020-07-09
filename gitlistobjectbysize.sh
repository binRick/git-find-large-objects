#!/bin/bash -e

clean_up(){
    ENDED_TS=$(_ts)
    DURATION_MS=$(($ENDED_TS-$STARTED_TS))
    [[ -f "$tempFile" ]] && \
        file_lines="$(file_lines $tempFile)" && \
        file_bytes="$(file_bytes $tempFile)" && \
        ansi --yellow --bold "Removing temp file $tempFile of $file_lines lines and $(humanize_bytes $file_bytes) after ${DURATION_MS}ms." && \
        unlink "$tempFile"        
    [[ -f "$execution_dir/.gitignore" ]] && \
        grep -q "$RESULTS_FILENAME" "$execution_dir/.gitignore" || \
            { ansi --yellow "Adding $RESULTS_FILENAME to $execution_dir/.gitignore" && \
                echo -e "$RESULTS_FILENAME" >> "$execution_dir/.gitignore"; }
}

setup(){
    execution_dir="$(realpath "$(pwd)")"
    base_dir="$( cd "$( dirname "$(realpath "${BASH_SOURCE[0]}")" )" && pwd )"
    source $base_dir/.ansi.sh
    source $base_dir/constants.sh
    source $base_dir/utils.sh
    STARTED_TS=$(_ts)
    tempFile=$(mktemp)
    trap clean_up EXIT
    IFS=$'\n'
}

collect_commit_hashes(){
    for commitSHA1 in $(git rev-list --all); do
	    git ls-tree -r --long "$commitSHA1" >>"$tempFile"
    done
}

sort_hash_sizes(){
  sort --key 3 "$tempFile" | \
	uniq | \
	sort --key 4 --numeric-sort --reverse | \
    tee $execution_dir/.git_objects_sorted_by_size.txt
}

limit_results(){
    head -n $DISPLAY_RESULTS_QTY
}

format_results(){
     tr -s ' ' |   sed 's/[[:space:]]/ /g'  | cut -d' ' -f3,4,5
}

main(){
    setup
    collect_commit_hashes
    sort_hash_sizes | \
        limit_results | \
        format_results
}


main
