#!/bin/bash
# Counts the number of each extension in a directory recursively.

find . -type f | while read line
do
    filename=$(basename "$line")
    extension=${filename##*.}
    echo $extension
done | sort | uniq -c
