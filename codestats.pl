#!/usr/bin/perl
# codestats.pl
# A perl script to calculate the number of lines of code in a project
# and what type of lines those code are, such as comments, code, or
# newlines. This script is specific to C/C++, but should be able to be
# adapted to other languages.
#
# Henry J Schmale
# April 30, 2015

use strict;
use warnings;

my @srcext = ("*.cpp", "*.c", "*.h", "*.hpp");

my $commLines = 0; # Lines that start with a comment symbol
my $bothLines = 0; # Lines that have a comment and code
my $newLines  = 0; # Lines that are just whitespace
my $codeLines = 0; # Lines of code - lines that don't fit in another space

my $files;
for($a = 0; $a < scalar(@srcext); $a++){
    $files .= `find . -name "$srcext[$a]"`;
}
my @inputs = split("\n", $files);
for($a = 0; $a < scalar(@inputs); $a++){
    print "Reading $inputs[$a]\n";
    countLines($inputs[$a]);
}
# print out the results
printf("Comment Lines: %d\n", $commLines);
printf("Blank Lines  : %d\n", $newLines);

# Count the lines in the given file
# The first param is the file to open for counting
sub countLines{
    my ($srcfile) = @_;
    open(FILE, "<$srcfile") or die "Couldn't open file: $!\n";
    my @lines = <FILE>;
    for($b = 0; $b < scalar(@lines); $b++){
        
    }
    close FILE;
}
