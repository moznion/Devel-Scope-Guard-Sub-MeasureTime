#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature qw/say/;

my @files = glob ('*.time');

my %bag;
for my $file (@files) {
    my ($package, $sub) = $file =~ /\A(.+?)#(.+?)\./;

    if (!defined $bag{$package}) {
        $bag{$package} = {};
    }

    if (!defined $bag{$package}->{$sub}) {
        $bag{$package}->{$sub} = [];
    }

    push @{$bag{$package}->{$sub}}, $file;
}

for my $package (keys %bag) {
    for my $sub (keys %{$bag{$package}}) {
        my $num = 0;
        my $sum = 0;
        for my $file (@{$bag{$package}->{$sub}}) {
            open my $fh, '<', $file or die $!;
            while (my $line = <$fh>) {
                chomp $line;
                if ($line) {
                    $sum += $line;
                    $num++;
                }
            }
        }
        printf "%s#%s\t%f [sec/req]\n", $package, $sub, ($sum / $num);
    }
}

