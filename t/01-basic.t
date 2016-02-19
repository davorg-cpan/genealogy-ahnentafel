use Test::More;
use Test::Exception;

BEGIN { use_ok 'Genealogy::Ahnentafel' };

my @gender_tests = qw[dummy Unknown Male Female Male Female Male Female];

foreach (1 .. $#gender_tests) {
  is(ahnen($_)->gender, $gender_tests[$_],
     "Gender for Ahnentafel $_ is correct");
}

my @generation_tests = (
  [1, 1], [3, 2], [5, 3], [11, 4], [24, 5], [40, 6], [98, 7],
);

foreach (@generation_tests) {
  is(ahnen($_->[0])->generation, $_->[1],
     "Ahnentafel $_->[0] is in generation $_->[1]");
}

my @description_tests = (
  [ Person => 1 ],
  [ Father => 2 ],
  [ Mother => 3 ],
  [ Grandfather => 4 ],
  [ Grandmother => 5 ],
  [ Grandfather => 6 ],
  [ Grandmother => 7 ],
  [ 'Great Grandfather' => 8 ],
  [ 'Great Grandmother' => 9 ],
);

foreach (@description_tests) {
  is(ahnen($_->[1])->description, $_->[0], "Person $_->[1] is a $_->[0]");
}

for (qw[1 4 7 14 81 123]) {
  ok(ahnen($_), "$_ is a valid Ahnentafel");
}

#throws_ok { ahnen() }
#          qr/did not pass type constraint/, 'Correct error thrown';

throws_ok { ahnen(0) }
          qr/did not pass type constraint/, 'Correct error thrown';

throws_ok { ahnen(-1) }
          qr/did not pass type constraint/, 'Correct error thrown';

throws_ok { ahnen(' ') }
          qr/did not pass type constraint/, 'Correct error thrown';

throws_ok { ahnen('A string') }
          qr/did not pass type constraint/, 'Correct error thrown';

done_testing;
