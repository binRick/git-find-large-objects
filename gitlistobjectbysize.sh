#!/bin/bash -e
tempFile=$(mktemp)
IFS=$'\n'
for commitSHA1 in $(git rev-list --all); do
	git ls-tree -r --long "$commitSHA1" >>"$tempFile"
done

time sort --key 3 "$tempFile" | \
	uniq | \
	sort --key 4 --numeric-sort --reverse | \
    tee $(pwd)/.git_objects_sorted_by_size.txt

rm "$tempFile"
