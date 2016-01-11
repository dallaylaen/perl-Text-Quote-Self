#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Text::Quote::Self' ) || print "Bail out!\n";
}

diag( "Testing Text::Quote::Self $Text::Quote::Self::VERSION, Perl $], $^X" );
