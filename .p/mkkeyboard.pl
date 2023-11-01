#!/usr/bin/env perl
# vim: fdm=marker :
use v5.14; use warnings; use autodie; use utf8;
use open qw( :encoding(UTF-8) :std );
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';

my $kbfile = shift;

my $kb = do { local $/; open my $f, '<', $kbfile; <$f> };
$kb =~ s,(?:^|(?<=\s))([A-Z]+)(?:$|(?=\s)),<span><span>$1</span></span>,g;
$kb =~ s,(?:^|(?<=\s))(\S)(\S)(?:$|(?=\s)),<span><span>$1</span><sup>$2</sup></span>,g;
$kb =~ s,(?:^|(?<=\s))(\S)(?:$|(?=\s)),<span><span>$1</span></span>,g;
$kb =~ s,\N{ARABIC LETTER HEH},$&\N{ZWJ},;
$kb =~ s,<sup>([\x{64D}\x{650}])</sup>,<sup class="submarks">&nbsp;$1</sup>,g;
$kb =~ s,<sup>([\x{64B}-\x{652}])</sup>,<sup class="marks">&nbsp;$1</sup>,g;

while (<>) {
  if (/id="keyboard"/) { s/></>$kb</g }
  print;
}


