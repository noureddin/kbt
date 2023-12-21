#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw( :encoding(UTF-8) :std );
sub slurp(_) { local $/; open my $f, '<', $_[0]; return scalar <$f> }

my $kb = slurp '.p/kb';

while (<>) {
  s|<<keyboard>>|$kb|;
  print;
}


