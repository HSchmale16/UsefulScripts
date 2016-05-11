#!/bin/bash

find . -type f | while read line
do
    filename=$(basename "$line")
    extension=${filename##*.}
    echo $extension
done | sort | uniq -c
