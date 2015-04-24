#!/bin/bash
#
# Initializes a new cpp project in the current directory
# Grabs a nice project makefile from github and the gitignore from
# github.
# 
# Henry J Schmale
# April 12, 2015
#
# Accepts the following parameters
# $1 - project name
# $2 - output binary name

# get the makefile
wget https://raw.githubusercontent.com/HSchmale16/GenericMakefile/master/cpp/Makefile -O makefile
# edit the makefile with perl
perl -pi -e 's/hello/$2/g' makefile

# get the gitignore and set it up to work with the makefile
wget https://raw.githubusercontent.com/github/gitignore/master/C%2B%2B.gitignore -o .gitignore
echo "*.d"   >> .gitignore
echo "bin/*" >> .gitignore

# Create necessary files & put stuff in them
touch readme.md
if [ -z $1 ] ; then
    echo "# $1" > readme.md
fi

touch main.cpp
echo '/**\file main.cpp' >> main.cpp
echo " * \\author $(git config user.name)" >> main.cpp
echo " * \\date $(date)" >> main.cpp
echo " */" >> main.cpp
echo "\n int main(int argc, char*argv){\n\n}"

# Say end message for what the user still has to do"
echo "Project Creation Complete!"
echo "Now edit the makefile to include the libraries you need for your project and title" \
     " your project's binary"
