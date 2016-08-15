#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: calcMostViewed.pl
#
#        USAGE: ./calcMostViewed.pl  
#
#  DESCRIPTION: Calculates the most viewed pages on my website, and outputs
#               a json file describing the most viewed files. 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Henry J Schmale (hschmale16@gmail.com), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 08/14/2016 10:25:44 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use JSON;

my $jsonFile = "pageviews.json";

my %postViewCount;
if (open(my $fh, '<', $jsonFile)){
    binmode $fh;
    my $json = <$fh>;
    close $fh;
    %postViewCount = %{decode_json($json)};
}

while(<>) {
    $_ = getHttpRequestFromLogLine();
    @_ = split;
    if( $_[1] =~ m/\/[0-9]{2}.+\.html/ ){
        $postViewCount{$_[1]}++;
    }
}

my $jsonstr = encode_json(\%postViewCount);
open(my $fh, '>', $jsonFile) or die $!;
print $fh $jsonstr;
close $fh;

sub getHttpRequestFromLogLine {
    chomp;
    s/\s+/ /go;
    my ($clientAddress,    $rfc1413,      $username, 
        $localTime,         $httpRequest,  $statusCode, 
        $bytesSentToClient, $referer,      $clientSoftware) =
    /^(\S+) (\S+) (\S+) \[(.+)\] \"(.+)\" (\S+) (\S+) \"(.*)\" \"(.*)\"/o;
    return $httpRequest;
}
