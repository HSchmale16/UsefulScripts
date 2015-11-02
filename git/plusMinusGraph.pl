#!/usr/bin/env perl

use strict;
# use warnings;

# Indexed by date
my %commits;

# get the git log
my $gitlogOutput = qx(git log --numstat --pretty="%H %aI" | grep -v '^\$');


my @lines = split /\n/, $gitlogOutput;
my $date;
my $hash;
foreach (@lines) {
    chomp;
    my @fields = split /\s+/;
    # Length of sha1sum
    if(length($fields[0]) > 39){
        $hash = $fields[0];
        $date = substr($fields[1], 0, 10);
    }else{
        $commits{$date}->{ins} += $fields[0];
        $commits{$date}->{del} -= $fields[1];
    }
}

foreach (keys %commits){
    print "$_\t$commits{$_}->{ins}\t$commits{$_}->{del}\n";
}
