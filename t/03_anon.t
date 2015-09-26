use strict;
use warnings;
use utf8;
use Time::HiRes;
use Devel::Scope::Guard::Sub::MeasureTime qw/measure_sub_time/;

use Test::More;

sub setup {
    unlink glob "main#__ANON__.*.time";
    unlink glob "main#aliased.*.time";
}

sub teardown {
    unlink glob "main#__ANON__.*.time";
    unlink glob "main#aliased.*.time";
}

my $dummy1 = sub {
    my $guard = measure_sub_time();
    Time::HiRes::usleep(1000 * 1000);
};

my $dummy2 = sub {
    my $guard = measure_sub_time('aliased');
    Time::HiRes::usleep(1000 * 1000);
};

subtest 'anon' => sub {
    setup();

    $dummy1->();
    $dummy1->();

    open my $fh, '<', "main#__ANON__.$$.time" or die $!;
    my $data = do { local $/; <$fh> };

    my @lines = split /\n/, $data;

    is scalar @lines, 2;

    ok $lines[0] =~ /\A1.[0-9]{0,6}\Z/;
    ok $lines[1] =~ /\A1.[0-9]{0,6}\Z/;

    teardown();
};

subtest 'alias' => sub {
    setup();

    $dummy2->();
    $dummy2->();

    open my $fh, '<', "main#aliased.$$.time" or die $!;
    my $data = do { local $/; <$fh> };

    my @lines = split /\n/, $data;

    is scalar @lines, 2;

    ok $lines[0] =~ /\A1.[0-9]{0,6}\Z/;
    ok $lines[1] =~ /\A1.[0-9]{0,6}\Z/;

    teardown();
};

done_testing;

