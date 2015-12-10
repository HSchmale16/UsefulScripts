#!/usr/bin/env perl
# Henry J Schmale
# November 27, 2015

use strict;
use warnings;
package main;

# Get the path to the stylesheet first
use File::Spec;
use File::Basename;
use DateTime;
use Date::Parse;
use JSON;

# CD into the directory specified if specified 
if(defined $ARGV[0]){
    if(-e $ARGV[0] and -d $ARGV[0]){
        chdir $ARGV[0];
    }
}

# Indexed by date
my %commits;

# get the git log and preprocess it
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
        $commits{$date}->{del} += $fields[1];
    }
}



my $firstDate = getDateTime(((sort keys %commits)[0]));
my $lastDate  = getDateTime(((sort keys %commits)[-1]));

while($firstDate->add(days => 1) < $lastDate){
    my $key = $firstDate->ymd('-');
    if(!defined $commits{$key}){
        $commits{$key}->{ins} = 0;
        $commits{$key}->{del} = 0;
    }
}

for my $c(sort keys %commits){
    print $c,",",$commits{$c}{ins},",",$commits{$c}{del},"\n";
}


sub getDateTime {
    my ($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($_[0]);
    return DateTime->new(
        day => $day,
        month => $month + 1,
        # We have to add 1900 here inorder to make the date format work
        year  => ($year + 1900)
    );
}

