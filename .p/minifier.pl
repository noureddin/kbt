#!/usr/bin/env perl
use v5.14; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

die "must provide an argument: js, css, or html\n"
  unless @ARGV;

my @files = @ARGV[1..$#ARGV];

# NOTE: exactly three passes give the smallest size; more would inline play() but keep its definition so it'd give larger results
exec qw[ deno run --quiet --allow-read npm:uglify-js --compress top_retain=[play],passes=3 --mangle toplevel,reserved=[play] ], @files
  if $ARGV[0] eq 'js';

exec qw[ deno run --quiet --allow-read npm:clean-css-cli ], @files
  if $ARGV[0] eq 'css';

exec qw[ perl -CSAD .p/html-minify.pl ], @files
  if $ARGV[0] eq 'html';

die "Unexpect argument: '$ARGV[0]'; expected: js, css, or html\n";

