package Devel::Scope::Guard::Sub::MeasureTime;
use 5.008001;
use strict;
use warnings;
use Scope::Guard;
use Time::HiRes qw/gettimeofday tv_interval/;
use parent qw(Exporter);

our $VERSION = "0.01";
our @EXPORT_OK = qw/measure_sub_time/;

sub measure_sub_time {
    my @caller = caller;
    warn "[WARNING!!!] ENABLED MEASURING TIME (called `measure_sub_time()`) at $caller[1] line $caller[2]\n";

    my ($package, $filename, $line, $subroutine) = caller(1);
    $subroutine =~ s/::/#/g;

    # >>> Start to measure time
    my $time = [gettimeofday];

    return Scope::Guard->new(sub {
        my $elapsed = tv_interval($time);
        open my $fh, '>>', "$subroutine.$$.time";
        $fh->autoflush(1);
        print $fh "$elapsed\n";
    });
}

1;
__END__

=encoding utf-8

=head1 NAME

Devel::Scope::Guard::Sub::MeasureTime - It's new $module

=head1 SYNOPSIS

    use Devel::Scope::Guard::Sub::MeasureTime;

=head1 DESCRIPTION

Devel::Scope::Guard::Sub::MeasureTime is ...

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

