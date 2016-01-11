#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use Text::Quote::Self qw(quote_text);

my $safe = quote_text( "fast food" );

$safe =~ s/foo/bar/;

is ("$safe", "fast bard", "Regex executed on original text");

done_testing;
