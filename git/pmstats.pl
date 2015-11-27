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

my $json = JSON->new->allow_nonref;

my %hash;

$hash{cols} = [
    {
        type => 'string',
        name => 'dates'
    },
    {
        type => 'number',
        name => 'Insertions'
    },
    {
        type => 'number',
        name => 'Deletions'
    },
    {
        type => 'number',
        name => 'Net Result'
    }
];
$hash{data} = ();

my $i = 0;
foreach (sort keys %commits){
    $hash{data}[$i] = [
        $_, 
        $commits{$_}{ins}, 
        -$commits{$_}{del},
        $commits{$_}{ins} - $commits{$_}{del}
    ];
    $i++;
}

my $string = do{local $/; <main::DATA>};

use Text::Template;
my $templ = Text::Template->new(
    SOURCE => $string,
    TYPE => 'string',
    DELIMITERS => ['{!', '!}']
);
my %vars = (
    title => 'Insertions and Deletions',
    subtitle => "Per day",
    jsonstr => $json->encode(\%hash),
);
my $result = $templ->fill_in(HASH => \%vars);

 if (defined $result) { print $result }
         else { die "Couldn't fill in template: $Text::Template::ERROR" }

sub getDateTime {
    my ($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($_[0]);
    return DateTime->new(
        day => $day,
        month => $month + 1,
        # We have to add 1900 here inorder to make the date format work
        year  => ($year + 1900)
    );
}


__DATA__
<html>
<head>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <script type="text/javascript">
    google.load('visualization', '1', {packages: ['corechart']});
    google.setOnLoadCallback(drawChart);

    function drawChart() {

      var data = new google.visualization.DataTable();
      var json = {! $jsonstr !};

      json.cols.forEach(function(e, i, a){data.addColumn(e.type, e.name)});
      data.addRows(json.data);

      var options = {
        chart: {
          title: '{! $title !}',
          subtitle: '{! $subtitle !}'
        },
        width: 1000,
        height: 600
      };

      var chart = new google.visualization.AreaChart(document.getElementById('line_top_x'));

      chart.draw(data, options);
    }
  </script>
</head>
<body>
  <div id="line_top_x"></div>
</body>
</html>

