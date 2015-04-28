#!/usr/bin/perl
# Henry J Schmale
# April 28, 2015
#
# Autoversion Script
# A script to make an autoversion header for C/C++ projects using something
# like semantic versioning. This script is meant to work on a project that
# is in a git repo. This script actually needs to sit in your project folder
# to work right.
#
# usage in (makefile for gnu make):
#   version.h: $(SRC)
#       @./autoversion.pl

my $commit = `git rev-list HEAD --count`;
my $myd    = `date +%m/%d/%Y`;
my $vh     = "version.h";

# get the original file contents and version information
if(-e $vh){
    # load the version header and parse it
}else{
    # must be a new project or an idiot deleted the version.h and screwed
    # up the versioning system
    my $major = 0;
    my $minor = 0;
    my $build = 0;
    my $rev   = 0;
}

# Prepare the contents
$con =
    "#ifndef VERSION_H_INC\n".
    "#define VERSION_H_INC\n".
    "const int  MAJOR        = $major;\n".
    "const int  MINOR        = $minor;\n".
    "const int  REVISION     = $rev\n;".
    "const int  COMMIT       = $commit;\n".
    "const int  BUILD        = $build;\n".
    "const char VERS_STR[]   = \"$major.$minor.$build.$rev\";\n".
    "const char BUILD_DATE[] = \"$myd;\"\n".
    "#endif // VERSION_H_INC\n";
    
# Write it out
open(OUT, '>', $vh) or die "Failed to open file: $!";
