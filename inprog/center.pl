#!/usr/bin/perl
# Centers lines of text read in on standard input
$c=`tput cols`;
while(<>){
    chomp;
    $d=(80-length($_)) / 2;
    print ' ' x $d,$_,"\n";
}
    
