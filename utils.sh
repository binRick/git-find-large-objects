file_lines(){
    mapfile -tn 0 lines < "$1"
    printf '%s\n' "${#lines[@]}"
}

file_bytes(){
    stat --printf="%s" "$1"
}

humanize_bytes(){
    numfmt --to=iec-i --suffix=B --padding=7 "$1" | sed 's/[[:space:]]//g'
}

_ts(){
    date +%s%3N
}

