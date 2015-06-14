#!/usr/bin/perl
# Henry J Schmale
# Jun3 14, 2015
#
# Usage: [Table Name] [Col 0 .. Col n]
# Input is read from stdin and the insert statements
# are writen to stdout

use strict;
use warnings;

my (@colnames) = @ARGV;
my $sqltable = $ARGV[0];

while(my $line = <STDIN>){
    chomp($line);
    $line =~ s/^\s+|\s+$//g;
    my @vals = split(',', $line);
    my $q = "INSERT INTO $sqltable(";
    for(my $a = 1; $a < scalar(@colnames) - 1; $a++){
        $q .= "$colnames[$a],";
    }
    $q .= "$colnames[scalar(@colnames)-1])VALUES(";
    for(my $a = 0; $a < scalar(@vals)-1; $a++){
        $q .= "'$vals[$a]',";
    }
    $q .= "'$vals[scalar(@vals)-1]');";
    print "$q\n";
}
