#!/usr/bin/perl
# Henry J Schmale
# April 28, 2015
#
# Autoversion Script
# A script to make an autoversion header for C/C++ projects
#
# usage:
#   version.h: $(SRC)
#       @./autoversion.pl

$rev = `git rev-list HEAD --count`;
$myd = `date +%m/%d/%Y`;
$vh  = "version.h";

# Prepare the contents
$con =
    "#ifndef VERSION_H_INC\n".
    "#define VERSION_H_INC\n".
    "const int REVSION = $rev;\n".
    "const char BUILD_DATE[] = \"$myd;\"\n".
    "#endif // VERSION_H_INC\n";
    
