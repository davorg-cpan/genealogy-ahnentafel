use Test::More;
use Test::Exception;

BEGIN { use_ok 'Genealogy::Ahnentafel' };

my @gender_tests = qw[dummy Unknown Male Female Male Female Male Female];

foreach (1 .. $#gender_tests) {
  is(gender($_), $gender_tests[$_], "Gender for Ahnentafel $_ is correct");
}

my @generation_tests = (
  [1, 1], [3, 2], [5, 3], [11, 4], [24, 5], [40, 6], [98, 7],
);

foreach (@generation_tests) {
  is(generation($_->[0]), $_->[1],
     "Ahnentafel $_->[0] is in generation $_->[1]");
}

for (qw[1 4 7 14 81 123]) {
  ok(Genealogy::Ahnentafel::is_valid($_), "$_ is a valid Ahnentafel");
}

throws_ok { Genealogy::Ahnentafel::is_valid() }
          qr/No Ahnentafel number given at/, 'Correct error thrown';

throws_ok { Genealogy::Ahnentafel::is_valid(0) }
          qr/Ahnentafel numbers start at 1/, 'Correct error thrown';

throws_ok { Genealogy::Ahnentafel::is_valid(-1) }
          qr/is not a valid Ahnentafel number/, 'Correct error thrown';

throws_ok { Genealogy::Ahnentafel::is_valid(' ') }
          qr/is not a valid Ahnentafel number/, 'Correct error thrown';

throws_ok { Genealogy::Ahnentafel::is_valid('A string') }
          qr/is not a valid Ahnentafel number/, 'Correct error thrown';

done_testing;
