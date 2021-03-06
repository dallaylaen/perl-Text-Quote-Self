package Text::Quote::Self;

use 5.006;
use strict;
use warnings;

=head1 NAME

Text::Quote::Self - Pack unsafe strings into self-quoting objects.

=head1 VERSION

Version 0.01

=cut

our $VERSION = 0.0103;

=head1 SYNOPSIS

In one part of your app:

    use Text::Quote::Self qw(quote_text);

	my $safe = quote_text($user_input);

Elsewhere:

    use Text::Quote::Self;

	local $Text::Quote::Self::Style = "as_html";
    print $safe; # now with &gt;
    print $safe->as_uri; # uri-escaped
    save_to_database( $safe->as_is ); # unmodified

=head1 EXPORT

=head2 quote_text( $initial_string )

Shorter constructor alias.
Returns a Text::Quote::Self instance containing original text.

=cut

use Carp;
use URI::Escape qw(uri_escape);

use overload '""' => "as_string";
use parent qw(Exporter);
our @EXPORT_OK = qw( quote_text );

sub quote_text {
	return __PACKAGE__->new(@_);
};

=head1 METHODS

=head2 new( $initial_string )

Constructor. So far, no arguments other than a string may be passed.

=cut

sub new {
	my ($class, $text) = @_;

	croak "$class: constructor requires a string"
		if !defined $text or ref $text;

	return bless \$text, $class;
};

=head2 as_string

Stringify contained value according to $Text::Quote::Self::Style value.
If not given, default to C<as_is>.

This method is called whenever Text::Quote::Self object is used in string
context.

Possible values include C<as_is>, C<as_uri>, and C<as_html>.

If style is set to unknown value, an exception will be thrown.

=head3 as_is

Return original string.

B<NOTE> Regular expression substitutions will have permanent effect
on the contained string.

=head3 as_uri

Return the string uri-encoded (%XX%XX). URI::Escape is used.

=head3 as_html

Return the string with C<&>, C<\<>, C<\>>, and C<"> quoted via HTML entities.


=cut

our $Style;

my %methods = qw(
	as_is     as_is
	as_html   as_html
    as_uri 	  as_uri
);

sub as_string {
	my $self = shift;

	my $method = $methods{ $Style || "as_is" };
	# TODO maybe check upon var set? Would require tie() or smth though
	croak __PACKAGE__. ": unknown escaping method $Style"
		unless $method;

	return $self->$method;
};

sub as_is {
	# HACK! Let $x =~ s/foo/bar do what it means
	return ${ $_[0] };
};

my %html_replace = qw( & &amp; < &lt; > &gt; " &quot; );
sub as_html {
	my $text = pop;
	$text = $$text if ref $text;

	$text =~ s#([&<>"])#$html_replace{$1}#g;
	return $text;
};

sub as_uri {
	my $text = pop;
	$text = $$text if ref $text;

	return uri_escape( $text );
};

=head2 TO_JSON

If serialized to JSON, a Text::Quote::Self instance will always return
the original string.

=cut

sub TO_JSON {
	my $self = shift;
	return $$self;
};

=head1 AUTHOR

Konstantin S. Uvarin, C<< <khedin at gmail.com> >>

=head1 BUGS

Probably lots of them - this software is still in alpha stage.

Please report any bugs or feature requests to C<bug-text-escape-self at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Quote-Self>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::Quote::Self


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Quote-Self>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Text-Quote-Self>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Text-Quote-Self>

=item * Search CPAN

L<http://search.cpan.org/dist/Text-Quote-Self/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Konstantin S. Uvarin.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Text::Quote::Self
