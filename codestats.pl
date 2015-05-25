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
my $totLines  = 0; # Total lines of code
my $srcBytes  = 0; # Total Number of bytes in src code
my $fCount    = 0; # Number of files read

my $files;
for($a = 0; $a < scalar(@srcext); $a++){
    $files .= `find . -name "$srcext[$a]"`;
}
my @inputs = split("\n", $files);
for($a = 0; $a < scalar(@inputs); $a++){
    print "Reading $inputs[$a]\n";
    countLines($inputs[$a]);
    $fCount++;
}
printResults();

# Count the lines in the given file
# The first param is the file to open for counting
sub countLines{
    my ($srcfile) = @_;
    open(FILE, "<$srcfile") or die "Couldn't open file: $!\n";
    my @lines = <FILE>;
    for($b = 0; $b < scalar(@lines); $b++){
        $srcBytes += length($lines[$b]);
        $totLines++;
        if($lines[$b] =~ /^\s$/){ # is only whitespace ==> newLine
            $newLines++;
            next;
        }
        if(($lines[$b] =~ /^\s*\/\//) || # comments only lines
           ($lines[$b] =~ /^\s*\/\*/) ||
           ($lines[$b] =~ /^\s*\*/)){
            $commLines++;
            next;
        }
        # code + comments
        if(($lines[$b] =~ /\/\//) ||
           ($lines[$b] =~ /\/\*.*\*\//)){
            $bothLines++;
            next;
        }
        $codeLines++;
    }
    close FILE;
}

sub calcPercent{
    return ($_[0] / $_[1]) * 100.0;
}

sub printResults{
    # print out the results
    printf("Read %d Files\n", $fCount);
    printf("Average Lines Per File: %d\n", $totLines / $fCount);
    printf("Code    : %09d  %06.3f\n", $codeLines, calcPercent($codeLines, $totLines));
    printf("Comment : %09d  %06.3f\n", $commLines, calcPercent($commLines, $totLines));
    printf("Blank   : %09d  %06.3f\n", $newLines,  calcPercent($newLines,  $totLines));
    printf("Both    : %09d  %06.3f\n", $bothLines, calcPercent($bothLines, $totLines));
    printf("Total   : %09d\n", $totLines);
    printf("Bytes of code: %d\n", $srcBytes);
}
