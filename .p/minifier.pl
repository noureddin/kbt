#!/usr/bin/env perl
use v5.14; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

die "must provide an argument: js, css, or html\n"
  unless @ARGV;

exec qw[ deno run --quiet --allow-read npm:uglify-js --compress top_retain='[play,mapping]',passes=5 --mangle toplevel,reserved='[play,mapping]' ], @ARGV[1..$#ARGV]
  if $ARGV[0] eq 'js';

exec qw[ deno run --quiet --allow-read npm:clean-css-cli ], @ARGV[1..$#ARGV]
  if $ARGV[0] eq 'css';

exec qw[ perl -CSAD .p/html-minify.pl ], @ARGV[1..$#ARGV]
  if $ARGV[0] eq 'html';

die "Unexpect argument: '$ARGV[0]'; expected: js, css, or html\n"

