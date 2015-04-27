#!/usr/bin/perl
# Prepares a class of that name with a default ctor with seperate
# declaration and implemenation
#
# Henry J Schmale
# April 27, 2015

print "Class name = ";
$cname = <STDIN>;

print "Has base class (y/n)? ";
if(<STDIN> =~ /y/){

}

# Construct file contents
$hpp = "#ifndef $cname""_H_INC\n"
       "#define $cname""_H_INC\n"
       "class $cname 

open(HEADER, "include/$cname.h") or die "Failed to open header for writing";
open(SRC, "src/$cname.cpp") or die "Failed to open source for writting";

