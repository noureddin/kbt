#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

sub slurp_stdin() { local $/; return scalar <> }

print slurp_stdin =~ s,<!----.*?-->,,sgr;
