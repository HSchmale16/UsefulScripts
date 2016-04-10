#!/usr/bin/perl
#
#

use MIME::Lite;
use File::Basename;

my $msg = MIME::Lite->new(
    From => 'logs@henryschmale.org',
    To => $ARGV[1],
    Subject => 'My Logs',
    Type => 'multipart/mixed',
);

$msg->attach(
    Type => 'application/bzip2',
    Path => $ARGV[0],
    Filename => basename($ARGV[0])
);

print "Sending $ARGV[0] to $ARGV[1].\n";

$msg->send;
