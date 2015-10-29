#!/bin/bash
# quick and dirty translate script.
# USAGE: ./trupdate <FILE> <ID_FIELD> <VALUE_FIELD>

function rmEXT {
    f=${1##*/}
    b=${f%.*}
    echo $b
}

# CMD ARGS
FILE=$1
ID_FIELD=$2
FIELD=$3

# Prepare to generate update statements by getting table name
TABLE=$(rmEXT ${FILE})

# begin business logic
cat $FILE | cut -d, "-f${ID_FIELD},${FIELD}" | while read line
do
    f=$(echo $line | cut -d, -f${FIELD})
    id=$(echo $line | cut -d, -f1)
    ftrd=$(echo $f | tr ' ' '-' | tr -s '-' | tr -cd '[[:alnum:]]-' \
        | tr 'A-Z' 'a-z')

    echo "UPDATE $TABLE SET URLTITLE='$ftrd' WHERE ID=$id;"
done 
