#!/usr/bin/env bash
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
# ./git2gdrive <LOCAL_DIR_TO_BKUP> <GDRIVE_DIR_TO_PLACE_IN>

LOCALDIR=$1
REMOTEDIR=$2

DATE=$(date +%Y-%m-%d)
TARNAME=/tmp/$(basename $LOCALDIR)$DATE.tbz

# Reduce the size of the directoy by doing some stuff with git and make
# I don't want to upload binaries to google drive
cd $LOCALDIR
echo $(pwd)
make clean
if [ -d ./.git ] ; then
    git gc --aggressive
fi
cd ..

echo $(pwd)

