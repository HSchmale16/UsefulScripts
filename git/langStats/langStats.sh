#!/bin/bash
# Calculates your use of programming languages over the entire time domain
# of your project.

# Sets the output filter


# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function getLangAtCommit() {
    git linguist stats --commit=$1 | tr -d '{}"' | tr , '\n'
}

function getCommitDate() {
    git show -s --format='%at' $1
}

git rev-list HEAD | while read commit
do
    langs=$(getLangAtCommit $commit)
    commDate=$(getCommitDate $commit)
    >&2 echo Commit at $(date -d "@$commDate") indexed
    echo $commDate $langs
done | perl $DIR/langStats-helper.pl > langStats.csv
gnuplot $DIR/t.gpi


