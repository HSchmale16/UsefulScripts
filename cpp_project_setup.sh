#!/bin/bash
#
# Initializes a new cpp project in the current directory
# Grabs a nice project makefile from github and the gitignore from
# github.
# 
# Henry J Schmale
# April 12, 2015

# get the makefile
wget https://raw.githubusercontent.com/HSchmale16/GenericMakefile/master/cpp/Makefile -O makefile

# get the gitignore
wget https://raw.githubusercontent.com/github/gitignore/master/C%2B%2B.gitignore
