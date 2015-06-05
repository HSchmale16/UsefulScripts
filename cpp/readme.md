# C++ Scripts
This directory contains scripts that are useful when working on C++ projects.
Many of these scripts will also work with projects that use languages similar
to C/C++

# Descriptions of each script
* Initialize a C++ project with a makefile and a skeleton main 
  function - `quick-cpp-setup.sh`.
* A script that is equalivalent to the autoversion plug-in for
  code blocks and works with gnu make. It creates a version.h file
  and talks to your git repo. It needs to be copied
  into your project directory for use, and called by your build system
  before starting your build. `autoversion.h`
* C++ class creation script, which prepares the skeleton of a class and
  a skeleton implementation of it, putting the declaration and implementation
  in seperate files. `makelass.pl`
* Code statistics script calculates the lines of code in a C/C++ (also works
  on java projects), and the types of lines of code. Prints the results in a
  similar fashion to the codeblocks plug-in. `codestats.pl`
