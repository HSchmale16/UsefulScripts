#!/bin/bash
# Accepts a single arg then uploads to google drive. 
# 
# ./compress2gdrive.sh <FILE>

if [ ! -f $1 ] ; then 
    echo $1 does not exist
fi
