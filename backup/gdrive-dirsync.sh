#!/bin/bash
# gdrive-dirsync.sh
# Henry J Schmale
# November 27, 2015
#
# Synchronizes a directory with one on google drive. I use this to
# synchronise my creeper world 3 game on my computers, and various other
# directories.
# 
# It should be noted that this script will not sync with the root directory
#
# This script requires the pramussan/gdrive tool in your path, and it should
# be named or aliased to `drive`.
#
# Usage:
# $0 <push|pull|help> <local-dir> <gdrive-dir>

function printScriptUsage() {
    echo USAGE:
    echo $0 '<push|pull|help> <local-dir> <gdrive-dirname>'
}


# Check and Parse args
CMD=$1
LOCAL_DIR=$2
GDRIVE_DIR=$3

case $CMD in
    push)
        ;;
    pull)
        ;;
    help)
        printScriptUsage
        exit
        ;;
    *)
        echo Invalid Command
        echo For help run: "$0 help"
        exit
        ;;
esac
