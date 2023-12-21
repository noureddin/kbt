#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];
sub slurp(_) { local $/; open my $f, '<', $_[0]; return scalar <$f> }

my %ar;
my %en;

for (glob '*/.info') {
  my $kb = s,/.*,,r;
  my $ar = 0==system('grep', '-q', 'ب', "$kb/.mapping.js");
  ($ar ? $ar{$kb} : $en{$kb}) = {};
  open my $f, '<', $_;
  while (<$f>) {
    if (/^\h*(?![#;])(\S+)\h*=\h*(.*?)\h*$/) {
      ($ar ? $ar{$kb} : $en{$kb})->{$1} = $2;
    }
  }
  close $f;
}

my %ar_n = map { $ar{$_}{name} ? ($_ => $ar{$_}{name}) : () } keys %ar;
my %en_n = map { $en{$_}{name} ? ($_ => $en{$_}{name}) : () } keys %en;

my $ar_k = join '', map { qq[<li><a href="$_">$ar_n{$_}</a></li>] } sort keys %ar_n;
my $en_k = join '', map { qq[<li><a href="$_">$en_n{$_}</a></li>] } sort keys %en_n;

while (<>) {
  s/\$\{ar_keyboards\}/<ul>$ar_k<\/ul>/g;
  s/\$\{en_keyboards\}/<ul>$en_k<\/ul>/g;
  print;
}


