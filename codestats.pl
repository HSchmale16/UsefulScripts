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

my $commLines = 0; # Lines that start with a comment symbol
my $newLines  = 0; # Lines that are just whitespace
my $codeLines = 0; # Lines of code - lines that don't fit in another space


sub countLines{
    my ($file) = @_;
    
}
