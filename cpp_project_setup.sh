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

# get the gitignore and set it up to work with the makefile
wget https://raw.githubusercontent.com/github/gitignore/master/C%2B%2B.gitignore -o .gitignore
echo "*.d"   >> .gitignore
echo "bin/*" >> .gitignore

# Create necessary files
touch readme.md
touch main.cpp

# Say end message for what the user still has to do"
echo "Project Creation Complete!"
echo "Now edit the makefile to include the libraries you need for your project and title" \
     " your project's binary"
