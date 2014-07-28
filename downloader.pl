#!/usr/bin/perl

use strict;
use warnings;
use boolean;

use WWW::Mechanize;
use Data::Dumper;
use LWP::UserAgent;
use JSON;

my %config = (
	'client_id' => '',
	'login' => '',
	'pass' => '',
	'token' => '',
);

my $access_url = "https://oauth.vk.com/authorize?client_id=$config{'client_id'}&scope=audio&redirect_uri=&display=page&response_type=token";

#####

my $mech = WWW::Mechanize->new( agent => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.97 Safari/537.22" );
my $res = $mech->get( $access_url );

die "Something went wrong: " . $res->is_success unless ( $res->is_success );

my $target_url = sprintf( "https://api.vk.com/method/audio.get?access_token=%s", $config{'token'} );
$res = $mech->get( $target_url );

die "Something went wrong: " . $res->is_success unless ( $res->is_success );

my $json = decode_json( $mech->content() );
die "No response in json" unless ( $json->{response} );

foreach my $song ( values $json->{response} ) {

	my ($ext) = $song->{url} =~ /(\.[^.]+)$/;

	$mech->get( $song->{url}, ":content_file" => $song->{artist}.' - '.$song->{title}.'.mp3' );

	print ".";

}
