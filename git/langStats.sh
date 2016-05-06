#!/bin/bash

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

    echo $commDate $langs
done | perl langStats-helper.pl


