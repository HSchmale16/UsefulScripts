#!/usr/bin/perl

use  strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);
use Data::Tabular::Dumper;

# lang => [{ date, value }]
my %langData;
my @langList;
while(<>){
    my @fields = split(' ');
    my @langs = splice(@fields, 1, $#fields);
    for my $l(@langs){
        my @split = split ':', $l;
        my %tmp = ( 
            date => $fields[0],
            val => $split[1]
        );
        push @{$langData{$split[0]}}, \%tmp;
        push @langList, $split[0];
    }
}



# date => { lang0 => value,
#           lang1 => value,
#           ... }
my %dateData;
for my $lang(keys %langData){
    for my $cmit (@{$langData{$lang}}){
        $dateData{%{$cmit}{date}}{$lang} = %{$cmit}{val};
    }
}

# add missing keys for a given date
@langList = uniq(@langList);
for my $date(keys %dateData){
    for my $lang(@langList){
        if(! exists $dateData{$date}{$lang}) {
            $dateData{$date}{$lang} = 0;
        }
    }
}

# print the csv
print Data::Tabular::Dumper->dump(\%dateData);




