#!/bin/bash
# Henry J Schmale
# October 14, 2015
# 
# Accepts a single arg then uploads to google drive into the backup
# directory.
# 
# ./compress2gdrive.sh <FILE>
 

if [ ! -f $1 ] ; then 
    echo $1 does not exist exit
    exit
fi

TMPFILE=/tmp/$(basename $1)
BZIPFILE=${TMPFILE}.bz2
REMOTEDIR="backup"

cp "$1" "$TMPFILE"
bzip2 $TMPFILE

# Prepare to upload
FOLDER_INFO=$(drive list | grep "$REMOTEDIR")

# Create backup folder because it does not exists yet and get the id of the
# parent to place file in
if [ -z "$FOLDER_INFO" ] ; then
    PARENT_ID=$(drive folder -t "$REMOTEDIR")
    PARENT_ID=$(echo $PARENT_ID | awk '{print $2}')
else
    PARENT_ID=$(echo "$FOLDER_INFO" | awk '{print $1}' | head -1)
fi

# Upload the file
drive upload -p "$PARENT_ID" -f "$BZIPFILE"
