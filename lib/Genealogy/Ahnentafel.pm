package Genealogy::Ahnentafel;

use strict;
use warnings;

require Exporter;
our @ISA = qw[Exporter];
our @EXPORT = qw[gender gender_string generation description];

use Carp;

our @GENDERS = qw[Male Female];
our @PARENTS = qw[Father Mother];

sub gender {
  is_valid(@_);

  return 'Unknown' if $_[0] == 1;
  return $GENDERS[ $_[0] % 2 ];
}

sub gender_string {
  is_valid(@_);

  return 'Unknown' if $_[0] == 1;
  return $PARENTS[ $_[0] % 2 ];
}

# Get the generation number from an Ahnentafel number.
# Person 1 is in generation 1
# Persons 2 & 3 are Person 1's parents and are in generation 2
# Persons 4, 5, 6 & 7 are Person 1's grandparents and are in generation 3
# etc ...
sub generation {
  is_valid(@_);

  return int log( $_[0] ) / log(2) + 1;
}

sub description {
  is_valid(@_);

  my $generation = generation(@_);

  return 'Person' if $generation == 1;

  my $root = gender_string(@_);
  return $root    if $generation == 2;
  $root = "Grand\L$root";
  return $root    if $generation == 3;
  my $greats = $generation - 3;
  return ('Great ' x $greats) . $root;
}

sub is_valid {
  @_             or croak "No Ahnentafel number given";
  $_[0] =~ /\D/ and croak "$_[0] is not a valid Ahnentafel number";
  $_[0] < 1     and croak "Ahnentafel numbers start at 1";
  return 1;
}
