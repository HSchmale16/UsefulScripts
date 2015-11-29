#!/bin/bash
# gdrive-dirsync.sh
# Henry J Schmale
# November 27, 2015
#
# Synchronizes a directory with one on google drive. I use this to
# synchronise my creeper world 3 game on my computers, and various other
# directories.
# 
# It should be noted that this script should be used to sync giant
# directories.
#
# This script requires the pramussan/gdrive tool in your path, and it should
# be named or aliased to `drive`.
#

# print the script usage message
function printScriptUsage() {
    echo "USAGE: "
    echo "$0 <push|pull|help> ..."
    echo
    echo "push - push a directory to a google drive directory."
    echo "       This will define the local directory as the master"
    echo "    $0 push <local-dir> <gdrive-dir>"
    echo "pull - pulls the changes from google drive to a local directory"
    echo "    $0 pull <local-dir> <gdrive-dir>"
    echo "help - display this help message"
}

# check that the script has it's dependicies that it needs
function checkDepends() {
    # check for required programs. Check the preamble for the required tools
    if type -p drive 2>&1 /dev/null
    then
        echo "You need the pramussan/gdrive tool to run this script"
        exit
    fi
    # check args
    if [ -z "$LOCAL_DIR" ]
    then
        echo "LOCAL_DIR is not specified"
        exit
    else
        if [ ! -d "$LOCAL_DIR" ]
        then
            echo "Local Dir Invalid"
            exit
        fi
    fi
    if [ -z "$GDRIVE_DIR" ]
    then
        echo "GDRIVE_DIR Invalid"
        exit
    fi
}

# Builds a listing of a local directory, places it into a file, and returns
# the name of the file.
function buildLocalList() { 
    TEMPFILE=$(mktemp)
    find "$LOCAL_DIR" | sort > $TEMPFILE
    echo $TEMPFILE
}

function dir-sync-push() {
    echo pushing
}

function dir-sync-pull() {
    echo pulling
}

# Check and Parse args
SCRIPTCMD=$1
LOCAL_DIR=$2
GDRIVE_DIR=$3

case $SCRIPTCMD in
    push|pull)
        checkDepends
        LOCALFILELIST=$(buildLocalList)
        echo $LOCALFILELIST
        ;;
    help)
        printScriptUsage $1
        exit
        ;;
    *)
        echo Invalid Command
        printScriptUsage
        exit
        ;;
esac
