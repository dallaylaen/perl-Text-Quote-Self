#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use Text::Quote::Self qw(safe_text);

my $unsafe = "<foo> &= <bar> .*";
my $safe   = safe_text( $unsafe );

is ("$safe", $unsafe, "Stringify round-trip");

note explain $safe;

is( $safe->as_uri, "%3Cfoo%3E%20%26%3D%20%3Cbar%3E%20.%2A", "as_uri (direct call)");

{
	local $Text::Quote::Self::Style = "as_html";
	is ("$safe", "&lt;foo&gt; &amp;= &lt;bar&gt; .*", "as_html ok");
};

is ("$safe", $unsafe, "Stringify round-trip again");


done_testing;
