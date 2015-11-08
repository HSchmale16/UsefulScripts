#!/bin/sh
# Henry J Schmale
# November 7, 2015
#
# Generate a list of random values
# -n how many to output
# -a min value in list
# -b max value in list

MIN=0
MAX=100
NUMBER=1

# Parse args
while getopts "n:a:b:" opt
do
    case $opt in
    n)
        NUMBER=$OPTARG
        ;;
    a)
        MIN=$OPTARG
        ;;
    b)
        MAX=$OPTARG
        ;;
    esac
done

let DIFF=MAX-MIN

i=1
while [[ $i -le $NUMBER ]]
do
    echo $(( ( RANDOM % $DIFF ) + $MIN ))
    let i=i+1
done


