#!/bin/bash
# Henry J Schmale
# git2gdrive.sh
# October 13, 2015
# 
# A Script to compress and upload a git repository to google drive. I
# recomend that you add this as a cronjob for directories you want backed
# up.
# 
# NOTE: This script requires https://github.com/prasmussen/gdrive to be
# in your path.
#
# USAGE:
# ./git2gdrive <LOCAL_DIR_TO_BKUP>
# 
# It is important to note that it will upload it to the `backup` folder in
# gdrive creating it if the folder does not exist


LOCALDIR=$1
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
TARNAME="/tmp/$(basename $LOCALDIR)$DATE.tbz"

cd $LOCALDIR
echo Enter $(pwd)

# Generate the archive
git archive --format=tar --prefix=$(basename $LOCALDIR)/ HEAD \
    | bzip2 > $TARNAME

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
