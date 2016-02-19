package Genealogy::Ahnentafel;

=head1 NAME

Genealogy::Ahnentafel - Handle Ahnentafel numbers in Perl.

=cut

use strict;
use warnings;

our $VERSION = '0.0.1';

require Exporter;
our @ISA = qw[Exporter];
our @EXPORT = qw[ahnen];

use Carp;

use Moo;
use MooX::ClassAttribute;
use Types::Standard qw( Str Int ArrayRef );
use Type::Utils qw( declare as where inline_as coerce from );

my $PositiveInt = declare
  as        Int,
  where     {  $_ > 0  },
  inline_as { "$_ =~ /^[0-9]+\$/ and $_ > 0" };

class_has genders => (
  is      => 'ro',
  isa     => ArrayRef[Str],
  lazy    => 1,
  builder => '_build_genders',
);

sub _build_genders {
  return [ qw[Male Female] ];
}

class_has parent_names => (
  is      => 'ro',
  isa     => ArrayRef[Str],
  lazy    => 1,
  builder => '_build_parent_names',
);

sub _build_parent_names {
  return [ qw[Father Mother] ];
}

has ahnentafel => (
  is       => 'ro',
  isa      => $PositiveInt,
  required => 1,
);

has gender => (
  is      => 'ro',
  isa     => Str,
  lazy    => 1,
  builder => '_build_gender',
);

sub _build_gender {
  my $ahnen = $_[0]->ahnentafel;
  return 'Unknown' if $ahnen == 1;
  return $_[0]->genders->[ $ahnen % 2 ];
}

has gender_description => (
  is      => 'ro',
  isa     => Str,
  lazy    => 1,
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
has generation => (
  is      => 'ro',
  isa     => $PositiveInt,
  lazy    => 1,
  builder => '_build_generation',
);

sub _build_generation {
  my $ahnen = $_[0]->ahnentafel;
  return int log( $ahnen ) / log(2) + 1;
}

has description => (
  is      => 'ro',
  isa     => Str,
  lazy    => 1,
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

has ancestry => (
  is      => 'ro',
  isa     => ArrayRef,
  lazy    => 1,
  builder => '_build_ancestry',
);

sub _build_ancestry {
  my @ancestry;
  my $curr = $_[0]->ahnentafel;

  while ($curr) {
    unshift @ancestry, ahnen($curr);
    $curr = int($curr / 2);
  }

  return \@ancestry;
}

has ancestry_string => (
  is      => 'ro',
  isa     => Str,
  lazy    => 1,
  builder => '_build_ancestry_string',
);

sub _build_ancestry_string {
  return join ', ', map { $_->description } @{ $_[0]->ancestry };
}

has father => (
  is      => 'ro',
  lazy    => 1,
  builder => '_build_father',
);

sub _build_father {
  return ahnen($_[0]->ahnentafel * 2);
}

has mother => (
  is      => 'ro',
  lazy    => 1,
  builder => '_build_mother',
);

sub _build_mother {
  return ahnen($_[0]->ahnentafel * 2 + 1);
}

sub ahnen {
  return Genealogy::Ahnentafel->new({ ahnentafel => $_[0] });
}

1;
