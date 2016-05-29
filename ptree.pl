#!/usr/bin/perl
#
#

use warnings;
use Cwd;
use File::Basename 'basename';
use Data::Dumper;
use Data::TreeDumper;
$Data::TreeDumper::Useascii = 0;

my $tree = {root => {}};
foreach my $input (<>) {
    chomp $input;
    my $t = $tree;
    $t = $t->{$_} //= {} for split '/' => $input;
}

print DumpTree($tree);
