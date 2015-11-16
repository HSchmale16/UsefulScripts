#!/usr/bin/env perl
# Henry J Schmale
# November 4, 2015
#
# Creates an insertion and delation graph per day graph for a git repo. It
# outputs an svg of the graph on standard output.
#
# This script can take the name of a directory to produce the graph for
# that directory if no param is given, then it does it in the current
# directory. 
#
# Requires SVG::TT:Graph::Line

use strict;
use warnings;

# Get the path to the stylesheet first
use File::Spec;
use File::Basename;
my $graphsty = dirname(File::Spec->rel2abs(__FILE__)) . '/svg-graph-ss.css';

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
# print scalar keys %commits;
# print "\n";

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
    # printf("%s,%s,%s,%s\n", $_, $ins[$i], $del[$i], $net[$i]);
    $i++;
}

# Get the max value in the data sets
my @allpoints;
my ($min, $max);
push @allpoints, @ins;
push @allpoints, @del;
push @allpoints, @net;
for(@allpoints){
    $min = $_ if !$min || $_ < $min;
    $max = $_ if !$max || $_ > $max;
}

# Graph it
use SVG::TT::Graph::Line;

my $graph = SVG::TT::Graph::Line->new({
        width => 1200,
        height => 800,
        fields => \@key,
        scale_integers => 1,
        rotate_x_labels => 1,
        show_data_values => 0,
        show_data_points => 0,
        min_scale_value => $min,
        max_scale_value => $max,
        style_sheet => $graphsty,
    });
# Add the data
$graph->add_data({
        'data' => \@ins,
        title => 'Inserts Per Day'
    });
$graph->add_data({
        'data' => \@del,
        title => 'Deletions Per Day'
    });
$graph->add_data({
        'data' => \@net,
        title => 'Net Insert/Del Per Day'
    });

# Print file 
my $filepath = '/tmp/gitGraph.svg';
open my $FD,'>',$filepath or die $!;
print $FD $graph->burn();
close $FD;

# Open it up in the browser or prefered method for opening the file
$filepath = 'file://'.$filepath;
qx(xdg-open $filepath);

sub getDateTime {
    my ($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($_[0]);
    # print "\t$_[0]\n";
    return DateTime->new(
        day => $day,
        month => $month + 1,
        # We have to add 1900 here inorder to make the date format work
        year  => ($year + 1900)
    );
}
