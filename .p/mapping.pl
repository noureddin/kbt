#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

my $kb = shift;
if (!-d $kb) { die "'$kb' is not a directory\n" }

while (<>) {
  1 while s[<<mapping>>][
    local $/;
    open my $f, "<", "$kb/.mapping.js";
    scalar(<$f>)
      =~ s,(\W)\s+,$1,gr =~ s,\s+(\W),$1,gr
      =~ s|[,;][\}]|}|gr
  ]ge;
  print;
}

