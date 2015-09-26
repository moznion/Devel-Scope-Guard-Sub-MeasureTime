use strict;
use warnings;
use utf8;
use Time::HiRes;
use Devel::Scope::Guard::Sub::MeasureTime qw/measure_sub_time/;

use Test::More;

sub setup {
    unlink glob "main#dummy1.*.time";
}

sub teardown {
    unlink glob "main#dummy1.*.time";
}

sub dummy1 {
    my $guard = measure_sub_time();
    Time::HiRes::usleep(1000 * 1000);
}

subtest 'basic' => sub {
    setup();

    dummy1();
    dummy1();

    open my $fh, '<', "main#dummy1.$$.time" or die $!;
    my $data = do { local $/; <$fh> };

    my @lines = split /\n/, $data;

    is scalar @lines, 2;

    ok $lines[0] =~ /\A1.[0-9]{0,6}\Z/;
    ok $lines[1] =~ /\A1.[0-9]{0,6}\Z/;

    teardown();
};

done_testing;

