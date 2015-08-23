#!/usr/bin/perl

use WWW::Sitemap;
use LWP::UserAgent;
 
my $ua = new LWP::UserAgent;
my $sitemap = new WWW::Sitemap(
    EMAIL       => 'your@email.address',
    USERAGENT   => $ua,
    ROOT        => 'http://localhost/'
);
 
$sitemap->url_callback(
    sub {
        my ( $url, $depth, $title, $summary ) = @_;
        print STDERR "URL: $url\n";
        print STDERR "DEPTH: $depth\n";
        print STDERR "TITLE: $title\n";
        print STDERR "SUMMARY: $summary\n";
        print STDERR "\n";
    }
);
$sitemap->generate();
$sitemap->option( 'VERBOSE' => 1 );
my $len = $sitemap->option( 'SUMMARY_LENGTH' );
 
my $root = $sitemap->root();
for my $url ( $sitemap->urls() )
{
    if ( $sitemap->is_internal_url( $url ) )
    {
        # do something ...
    }
    my @links = $sitemap->links( $url );
    my $title = $sitemap->title( $url );
    my $summary = $sitemap->summary( $url );
    my $depth = $sitemap->depth( $url );
}
$sitemap->traverse(
    sub {
        my ( $sitemap, $url, $depth, $flag ) = @_;
        if ( $flag == 0 )
        {
            # do something at the start of a list of sub-pages ...
        }
        elsif( $flag == 1 )
        {
            # do something for each page ...
        }
        elsif( $flag == 2 )
        {
            # do something at the end of a list of sub-pages ...
        }
    }
)
