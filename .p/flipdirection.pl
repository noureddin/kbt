#!/usr/bin/env perl
# vim: fdm=marker :
use v5.14; use warnings; use autodie; use utf8;
use open qw( :encoding(UTF-8) :std );
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';

if (@ARGV == 0 || $ARGV[0] =~ /\.html$/) {  # no args => assume html
  while (<>) {
    s/dir="rtl"/dir="ltr"/g;
    s,(<link\b[^<>]+\bhref="[^"]+/)(style[.]css),$1ltr-$2,g;
    print;
  }
}
elsif ($ARGV[0] =~ /\.css$/) {
  while (<>) {
    s/(left)|(right)/$1? 'right' : 'left'/ge;
    print;
  }
}
else {  # do nothing
  while (<>) {
    print;
  }
}
