#!/usr/bin/perl
#

use strict;
use warnings;

# Get input
print "Enter File name to process: ";
my $infile = <STDIN>;
print "Enter File to output to: ";
my $outfile = <STDIN>;
print "Enter SQL table name to insert to: ";
my $sqltable = <STDIN>;
print "Enter number of table columns: ";
my $tbcolnum = <STDIN>;
my @colnames;
for(my $a = 0; $a < $tbcolnum; $a++){
    print "Enter Column $a Name: ";
    $colnames[$a] = <STDIN>;
}

# Read file in and write sql queries to outfile
open(INFILE, "<$infile") or die "Can't open file: $!";
open(OUTFILE, ">$outfile") or die "Can't open file: $!";

while($line = <INFILE>){

}

close INFILE;
close OUTFILE;
