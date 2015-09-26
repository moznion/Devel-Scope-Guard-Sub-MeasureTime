use strict;
use warnings;
use utf8;
use t::Util;

use Test::More;

sub setup {
    unlink glob "t::Util#dummy1.*.time";
}

sub teardown {
    unlink glob "t::Util#dummy1.*.time";
}

subtest 'for package' => sub {
    # setup();

    t::Util::dummy1();
    t::Util::dummy1();

    open my $fh, '<', "t::Util#dummy1.$$.time" or die $!;
    my $data = do { local $/; <$fh> };

    my @lines = split /\n/, $data;

    is scalar @lines, 2;

    ok $lines[0] =~ /\A1.[0-9]{0,6}\Z/;
    ok $lines[1] =~ /\A1.[0-9]{0,6}\Z/;

    teardown();
};

done_testing;

