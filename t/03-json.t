#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

my $can_json = eval { require JSON::XS; "JSON::XS" }
	|| eval { require JSON::PP; "JSON::PP" };

if (!$can_json) {
	plan skip_all => "JSON library not found, skipping";
	exit;
};

use Text::Quote::Self qw(quote_text);

my $js = $can_json->new->allow_blessed->convert_blessed;

my $safe = quote_text( "foo<>bar" );
my $hash = { key => $safe };

local $Text::Quote::Self::Style = "as_html";
my $text = $js->encode( $hash );
is ($js->decode( $text )->{key}, $safe->as_is, "JSON decode round-trip" );

done_testing;
