#!/usr/bin/env bash

function total-wc {
    wc $@ | tail -1
}

LATEX_FILES=$(find . -name '*.tex')
TXT_FILES=$(find . -name '*.txt')
MD_FILES=$(find . -name '*.md')

LATEX_WC=$(total-wc ${LATEX_FILES})
TXT_WC=$(total-wc ${TXT_FILES})
MD_WC=$(total-wc ${MD_FILES})

echo $LATEX_WC


