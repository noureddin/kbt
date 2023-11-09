#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw( :encoding(UTF-8) :std );

# assumes CSS
while (<>) {
  s/(left)|(right)/$1? 'right' : 'left'/ge;
  s/^\@font-face.*//g;
  s/"Kawkab Mono Fixed",//g;
  s/"KacstOne",//g;
  print;
}
