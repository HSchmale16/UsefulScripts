#!/bin/bash
# compress.sh
# A script for compressing the data files of the website, for faster transfer 
# of data to the client. It is also useful, for selectiving compressing
# files based on extension
#
# Henry J Schmale
# August 3, 2015

DOCROOT=/var/www/html/
COMPRESS_EXT=('*.json' '*.png' '*.html' '*.xml')

for ext in ${COMPRESS_EXT[*]}; do
    for file in $(find $DOCROOT -name $ext); do
        cat $file | gzip > ${file}.gz
    done
done
