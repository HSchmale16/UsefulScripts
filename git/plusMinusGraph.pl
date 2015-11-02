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

my (@key, @ins, @del);
my $i = 0;
foreach (sort keys %commits){
    $key[$i] = $_;
    $ins[$i] = $commits{$_}->{ins};
    $del[$i] = $commits{$_}->{del};
    $i++;
}

use GD::Graph::area;

my $graph = GD::Graph::area->new(800, 600);
$graph->set(
    x_label     => 'date',
    y_label     => 'Magic',
    title       => 'Git'
);

my @data = (\@key, \@ins, \@del);
$graph->plot(\@data);

my $format = $graph->export_format;
open(IMG, ">file.$format") or die $!;
binmode IMG;
print IMG $graph->plot(\@data)->$format();
close IMG;
