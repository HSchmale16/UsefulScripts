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

use strict;
use warnings;

# You can declare your versioning scheme here
use constant{
    MAX_MINOR   => 10,     # Max value of minor before incrementing major
    MAX_REV     => 10000,  # Max Value of rev before incrementing minor
    MAX_REV_ADD => 100     # Max value to add to rev each time called
};

my $commit = `git rev-list HEAD --count`;
my $myd    = `date +%m/%d/%Y`;
my $vh     = "version.h";
my $major  = 0;
my $minor  = 0;
my $build  = 0;
my $rev    = 0;

# get the original file contents and version information
if(-e $vh){
    # load the version header and parse it
    open( FILE, "<$vh") or die "Can't open file for reading: $!\n";
    my @lines = <FILE>;
    close FILE;
    for($a = 0; $a < scalar(@lines); $a++){
        if($lines[$a] =~ /MAJOR/){
            $major = $lines[$a];
            $major =~ s/[^0-9]//g;
        }
        if($lines[$a] =~ /MINOR/){
            $minor = $lines[$a];
            $minor =~ s/[^0-9]//g;
        }
        if($lines[$a] =~ /REVISION/){
            $rev = $lines[$a];
            $rev =~ s/[^0-9]//g;
        }
        if($lines[$a] =~ /BUILD_COUNT/){
            $build = $lines[$a];
            $build =~ s/[^0-9]//g;
        }
    }
    # Increment Versions
    $build += 1;
    $rev += int(rand(MAX_REV_ADD));
    if($rev > MAX_REV){
        $rev = 0;
        $minor++;
        if($minor > MAX_MINOR){
            $major++;
            $minor = 0;
        }
    }
}

# Prepare the contents
$commit =~ s/\n//g;
my $con =
    "#ifndef VERSION_H_INC\n".
    "#define VERSION_H_INC\n".
    "const int  MAJOR        = $major;\n".
    "const int  MINOR        = $minor;\n".
    "const int  REVISION     = $rev;\n".
    "const int  COMMIT       = $commit;\n".
    "const int  BUILD_COUNT  = $build;\n".
    "const char VERS_STR[]   = \"$major.$minor.$build.$rev\";\n".
    "const char BUILD_DATE[] = \"$myd\";\n".
    "#endif // VERSION_H_INC\n";

# Write it out
open(FILE, "> $vh") or die "Couldn't open version header for writing: $!";
print FILE "$con";
close FILE;
