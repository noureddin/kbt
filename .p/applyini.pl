#!/usr/bin/env perl
# vim: fdm=marker :
use v5.14; use warnings; use autodie; use utf8;
use open qw( :encoding(UTF-8) :std );
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';

my $ini_file = shift;

my %defs;
open my $ini_fh, '<', $ini_file;
while (<$ini_fh>) {
  if (/^\h*(?![#;])(\S+)\h*=\h*(.*?)\h*$/) {
    $defs{$1} = $2;
  }
}
close $ini_fh;
for (@ARGV) {
  if (/^\h*(?![#;])(\S+)\h*=\h*(.*?)\h*$/) {
    $defs{$1} = $2;
  }
}

while (<STDIN>) {
  for my $kw (keys %defs) {
    s/\$\Q{$kw}\E/$defs{$kw}/g
  }
  print;
}

