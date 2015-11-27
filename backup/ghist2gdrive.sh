#!/bin/bash
# Henry J Schmale
# ghist2gdrive.sh
# November 12, 2015
#
# This script backs up a git repository with history and all to google
# drive. This script is not recomended to be used everytime, because it
# produces much larger archives than `git2gdrive.sh`. This script is more
# like a weekly thing than a daily thing.
# 
# NOTE: This script requires https://github.com/prasmussen/gdrive to be
# in your path.
#
# USAGE:
# ./git2gdrive <LOCAL_DIR_TO_BKUP> [ANYTHING]
# 
# If any thing is placed in the [ANYTHING] position then the remote sync
# feature will be enabled and it will fetch updates from a remote. You can
# enable this if you would like. It does not really matter. That state is
# not saved from run to run of this script.
#
# It is important to note that it will upload it to the `backup` folder in
# gdrive creating it if the folder does not exist


LOCALDIR=$1
ENABLE_REMOTE_SYNC=$2
REMOTEDIR="backup"

# Check that required programs are installed
# Please see the note in the preamble(at the top) for the required
# programs.
if type -p drive 2>&1 /dev/null
then
    echo \`drive\` is not in your path, add it to your path to use this \
        script.
    exit
fi

# You also need `git` to run this script
if type -p git 2>&1 /dev/null
then
    echo \`git\` is not installed. This is a required package for this \
        script.
    exit
fi

# Input Verification
# This stuff checks the arguements to the backup script.
if [ -z "$LOCALDIR" ]
then
    echo "You need to specify the directory to backup"
    exit
else
    if [ ! -d "$LOCALDIR" ]
    then
        echo "$LOCALDIR is not a directory"
        exit
    fi
fi

# Begin the meat of the script
DATE=$(date +%Y-%m-%d)
TARNAME="/tmp/$(basename $LOCALDIR)-${DATE}.bundle"

cd $LOCALDIR
echo Enter $(pwd)

# Fetch the latest updates from the remote if there is one
BRANCH_NAME=master
if [ ! -z $ENABLE_REMOTE_SYNC ]
then
    # on success return code is 0
    git ls-remote --exit-code
    if test $? != 0
    then
        echo "The remote is unreachable if you have one"
    else
        git fetch
        BRANCH_NAME=origin/master
    fi
fi

# Generate the archive
# In this case xz is better at archiving binary data, so that is used bzip2
git bundle create $TARNAME $BRANCH_NAME
xz $TARNAME
# Update the tarname
TARNAME=${TARNAME}.xz

# Prepare to upload
# Get the remote directory id to place the back up in.
FOLDER_INFO=$(drive list | grep "$REMOTEDIR")
echo Got Folder Info

# Create backup folder if it does not exists yet and get the id of the
# parent to place file in
if [ -z "$FOLDER_INFO" ]
then
    echo Folder does not exist creating the folder
    PARENT_ID=$(drive folder -t "$REMOTEDIR")
    PARENT_ID=$(echo $PARENT_ID | awk '{print $2}')
else
    PARENT_ID=$(echo "$FOLDER_INFO" | awk '{print $1}' | head -1)
fi

# Finally We can now upload the the backup tar to google drive
drive upload -p "$PARENT_ID" -f "$TARNAME"