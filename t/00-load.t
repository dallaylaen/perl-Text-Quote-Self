#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Text::Escape::Self' ) || print "Bail out!\n";
}

diag( "Testing Text::Escape::Self $Text::Escape::Self::VERSION, Perl $], $^X" );
