#!/bin/bash

SITEMAP_FILE=$1

cat $SITEMAP_FILE | \
    grep 'loc' | \
    sed 's/<[^>]*>//g' | \
    awk '{print $1}'
