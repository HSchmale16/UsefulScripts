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
    echo "USAGE: "
    echo "$0 <push|pull|help> <local-dir> <gdrive-dirname>"
}

# check that the script has it's dependicies that it needs
function checkDepends() {
    # check for required programs. Check the preamble for the required tools
    if type -p drive 2>&1 /dev/null
    then
        echo "You need the pramussan/gdrive tool to run this script"
        exit
    fi 
}

function dir-sync-push() {
}

function dir-sync-pull() {

}

# Check and Parse args
SCRIPTCMD=$1
LOCAL_DIR=$2
GDRIVE_DIR=$3

case $SCRIPTCMD in
    push|pull)
        checkDepends
        GDRIVE_LISTING=$(drive list)
        ;;
    help)
        printScriptUsage $1
        exit
        ;;
    *)
        echo Invalid Command
        echo "For help run: $0 help [cmd]"
        exit
        ;;
esac
