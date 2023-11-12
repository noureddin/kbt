#!/usr/bin/env perl
use v5.14; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

die "must provide an argument: js, css, or html\n"
  unless @ARGV;

my @files = @ARGV[1..$#ARGV];

exec qw[ deno run --quiet --allow-read npm:uglify-js --compress toplevel,passes=4 --mangle toplevel ], @files
  if $ARGV[0] eq 'js';

exec qw[ deno run --quiet --allow-read npm:clean-css-cli ], @files
  if $ARGV[0] eq 'css';

exec qw[ perl -CSAD .p/html-minify.pl ], @files
  if $ARGV[0] eq 'html';

die "Unexpect argument: '$ARGV[0]'; expected: js, css, or html\n";

