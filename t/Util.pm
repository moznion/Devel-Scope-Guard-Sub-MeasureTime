package t::Util;
use strict;
use warnings;
use utf8;
use Time::HiRes;
use Devel::Scope::Guard::Sub::MeasureTime qw/measure_sub_time/;

sub dummy1 {
    my $guard = measure_sub_time();
    Time::HiRes::usleep(1000 * 1000);
}

1;

