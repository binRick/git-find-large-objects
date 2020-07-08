#!/bin/bash -e
tempFile=$(mktemp)
IFS=$'\n'
for commitSHA1 in $(git rev-list --all); do
	git ls-tree -r --long "$commitSHA1" >>"$tempFile"
done

sort --key 3 "$tempFile" | \
	uniq | \
	sort --key 4 --numeric-sort --reverse

rm "$tempFile"
