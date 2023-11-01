#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

# adds a hash to static file names, as a querystring.

use Digest::file qw[ digest_file_base64 ];
sub hash(_) { digest_file_base64(shift, 'SHA-1') =~ tr[+/][-_]r }

sub cache { my ($src_pre, $dst_pre, $filename) = @_;
  my $hash =
    hash $src_pre . $filename;
  return $dst_pre . $filename . '?h=' . $hash;
}

my $kb = shift;
if (!-d $kb) { die "'$kb' is not a directory\n" }
my $root = $kb eq '.' ? '' : '../';

while (<>) {
  s{ (<link\b   [^<>]+ \bhref=") [.]s/([^<>"/]+[.]css) (?=") }{ $1 . cache("s/", $root."s/", $2) }gex;
  s{ (<script\b [^<>]+ \bsrc=")  [.]s/([^<>"/]+[.]js)  (?=") }{ $1 . cache("s/", $root."s/", $2) }gex;
  s{ (<script\b [^<>]+ \bsrc=")  [.]  ([^<>"/]+[.]js)  (?=") }{ $1 . cache("$kb/",  "",      $2) }gex;
  print;
}
