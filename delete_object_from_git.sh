#!/bin/bash -e
cmd="git filter-branch --tree-filter \"rm -f $1\" -- --all"

echo -e $cmd
