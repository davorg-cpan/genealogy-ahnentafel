package Genealogy::Ahnentafel;

use strict;
use warnings;

require Exporter;
our @ISA = qw[Exporter];
our @EXPORT = qw[ahnen];

use Carp;

use Moo;
use Types::Standard qw( Str Int ArrayRef );
use Type::Utils qw( declare as where inline_as coerce from );

my $PositiveInt = declare
  as        Int,
  where     {  $_ > 0  },
  inline_as { "$_ =~ /^[0-9]+\$/ and $_ > 0" };

has ahnentafel => (
  is  => 'ro',
  isa => $PositiveInt,
  required => 1,
);

has genders => (
  is  => 'ro',
  isa => ArrayRef[Str],
  lazy => 1,
  builder => '_build_genders',
);

sub _build_genders {
  return [ qw[Male Female] ];
}

has parent_names => (
  is  => 'ro',
  isa => ArrayRef[Str],
  lazy => 1,
  builder => '_build_parent_names',
);

sub _build_parent_names {
  return [ qw[Father Mother] ];
}

has gender => (
  is   => 'ro',
  isa  => Str,
  lazy => 1,
  builder => '_build_gender',
);

sub _build_gender {
  my $ahnen = $_[0]->ahnentafel;
  return 'Unknown' if $ahnen == 1;
  return $_[0]->genders->[ $ahnen % 2 ];
}

has gender_description => (
  is => 'ro',
  isa => Str,
  lazy => 1,
  builder => '_build_gender_description',
);

sub _build_gender_description {
  my $ahnen = $_[0]->ahnentafel;
  return 'Person' if $ahnen == 1;
  return $_[0]->parent_names->[ $ahnen % 2 ];
}

# Get the generation number from an Ahnentafel number.
# Person 1 is in generation 1
# Persons 2 & 3 are Person 1's parents and are in generation 2
# Persons 4, 5, 6 & 7 are Person 1's grandparents and are in generation 3
# etc ...
sub generation {
  my $ahnen = $_[0]->ahnentafel;
  return int log( $ahnen ) / log(2) + 1;
}

has description => (
  is => 'ro',
  isa => Str,
  lazy => 1,
  builder => '_build_description',
);
sub _build_description {
  my $ahnen = $_[0]->ahnentafel;

  my $generation = $_[0]->generation();

  return 'Person' if $generation == 1;

  my $root = $_[0]->gender_description;
  return $root    if $generation == 2;
  $root = "Grand\L$root";
  return $root    if $generation == 3;
  my $greats = $generation - 3;
  return ('Great ' x $greats) . $root;
}

sub ancestry {
  is_valid(@_);

  my @ancestry;
  my $curr = $_[0];

  while ($curr) {
    push @ancestry, gender_string($curr);
    $curr = int($curr / 2);
  }

  return reverse @ancestry;
}

sub ancestry_string {
  is_valid(@_);

  return join ', ', ancestry(@_);
}

sub is_valid {
  @_             or croak "No Ahnentafel number given";
  $_[0] =~ /\D/ and croak "$_[0] is not a valid Ahnentafel number";
  $_[0] < 1     and croak "Ahnentafel numbers start at 1";
  return 1;
}

sub ahnen {
  return Genealogy::Ahnentafel->new({ ahnentafel => $_[0] });
}

1;
