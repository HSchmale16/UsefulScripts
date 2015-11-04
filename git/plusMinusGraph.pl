#!/usr/bin/env perl
# Henry J Schmale
# November 4, 2015
#
# Creates an insertion and delation graph for a git repo.
# This script is ran directly in the git repo you want to query about and
# outputs an image file named `file.gif` or something to the like of that.
#
# Requires GD::Graph

use strict;
use warnings;

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
        $commits{$date}->{del} += $fields[1];
    }
}


use DateTime;
use Date::Parse;
use Data::Dumper;

my $firstDate = getDateTime(((sort keys %commits)[0]));
my $lastDate  = getDateTime(((sort keys %commits)[-1]));
# print "$firstDate\t".((sort keys %commits)[0])."\n";
# print "$lastDate\t".((sort keys %commits)[-1])."\n";

# print (scalar keys %commits)."\n";
while($firstDate->add(days => 1) < $lastDate){
    my $key = $firstDate->ymd('-');
    if(!defined $commits{$key}){
        $commits{$key}->{ins} = 0;
        $commits{$key}->{del} = 0;
    }
}
print scalar keys %commits;
print "\n";

# Prepare data for graphing by converting them to arrays
my (@key, @ins, @del, @net);
my $i = 0;
foreach (sort keys %commits){
    $key[$i] = $_;
    $ins[$i] = $commits{$_}{ins};
    # del must be negitive in order for graph to look right, with delations
    # being below the x axis.
    $del[$i] = -$commits{$_}{del};
    $net[$i] = $commits{$_}{ins} - $commits{$_}{del};
    printf("%s,%s,%s,%s\n", $_, $ins[$i], $del[$i], $net[$i]);
    $i++;
}

use GD::Graph::area;

my $GRAPH_WIDTH = 1000;
my $GRAPH_HEIGHT = 800;

my $graph = GD::Graph::area->new($GRAPH_WIDTH, $GRAPH_HEIGHT);
$graph->set(
    x_label     => 'date',
    y_label     => 'Insert / Delete Per Day',
    title       => 'Git Insert Delete Per Day'
);

my @data = (\@key, \@ins, \@del, \@net);
$graph->plot(\@data);

my $format = $graph->export_format;
open(IMG, ">file.$format") or die $!;
binmode IMG;
print IMG $graph->plot(\@data)->$format();
close IMG;

sub getDateTime {
    my ($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($_[0]);
    print "\t$_[0]\n";
    return DateTime->new(
        day => $day,
        month => $month + 1,
        # We have to add 1900 here inorder to make the date format work
        year  => ($year + 1900)
    );
}
