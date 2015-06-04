#!/bin/bash
# Henry J Schmale
# June 4, 2015
# Log Rotation Script
# Rotates logs for a web server, and zips them
# This script is meant to work on nfs hosting system, and it does need to
# be triggered manually.

mydate=$(date +%b%Y)

for f in $(find . -name "*_log"); do
    mv $f.old $f.$mydate
    gzip $f.$mydate 
done
