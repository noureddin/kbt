#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

# grep dirs that has both .kb & .ls
my @all = map { -e s,..$,ls,r ? s,.{4}$,,r : () } glob '*/.kb';

my @ar = grep { 0==system('grep', '-q', 'ب', "$_/.kb") } @all;
my @en = grep { 0!=system('grep', '-q', 'ب', "$_/.kb") } @all;

say 'PL=perl -CDAS -mutf8';
say '';
say "all: index.html @all";
say '';

sub read_name { my ($kb) = @_;
  open my $fh, '<', "$kb/.info";
  while (<$fh>) {
    if (/^\h*(?![#;])(\S+)\h*=\h*(.*?)\h*$/) {
      if ($1 eq 'name') {
        return $2;
      }
    }
  }
}

for my $ar (@ar) {
  my $title = read_name($ar).' — مدرب لوحات المفاتيح';
  say "$ar: $ar/index.html";
  say "$ar/index.html: .p/* $ar/.?? s/ar-words.js";
  say "\t"
     ."\$(PL) .p/mkkeyboard.pl $ar/.kb .p/html.html | "
     ."\$(PL) .p/mklessons.pl $ar/.ls | "
     ."\$(PL) .p/applyini.pl .p/arabic.ini keyboard=$ar title='$title' > $ar/index.html";
  say "";
}

for my $en (@en) {
  my $title = read_name($en).' — Keyboard Trainer';
  say "$en: $en/index.html";
  say "$en/index.html: .p/* $en/.?? s/en-words.js s/ltr-style.css";
  say "\t"
     ."\$(PL) .p/mkkeyboard.pl $en/.kb .p/html.html | "
     ."\$(PL) .p/mklessons.pl $en/.ls | "
     ."\$(PL) .p/flipdirection.pl | "
     ."\$(PL) .p/applyini.pl .p/english.ini keyboard=$en title='$title' > $en/index.html";
  say qq{\tsed 's|/style\.css"|/ltr-style.css"|' -i $en/index.html};
  say "";
}

say q{index.html: .p/home.html .p/mkhome.pl */.info};
say q{	$(PL) .p/mkhome.pl .p/home.html > index.html};
say q{};
say q{s/ltr-style.css: s/style.css};
say q{	$(PL) .p/flipdirection.pl s/style.css > s/ltr-style.css};
say q{};
say q{s/ar-words.js:};
say q{	# based on WikiSource Voweled Imalaai Quran Text};
say q{	# # the 3rd s-cmd in the 1st sed to move the shadda before the other vowel, b/c wikisource always puts it after the vowel.};
say q{	# sed 's/([0-9]\+)//g; s/ \+/\n/g; s/\(.\)ّ/ّ\1/g' quran | sort -u | grep -v ^$$ > voweled-imlaai-quran-words};
say q{	<.w/voweled-imlaai-quran-words sed 's/^/"/; s/$$/",/' | sed -ne '1iconst FULL_WORDS = [' -e 'p;$$i]' > s/ar-words.js};
say q{};
say q{s/en-words.js:};
say q{	# based on XKCD Simple Writer Word List 0.2.1};
say q{	<.w/xkcd-simple-writer-words sed 's/^/"/; s/$$/",/' | sed -ne '1iconst FULL_WORDS = [' -e 'p;$$i]' > s/en-words.js};
say q{};
say q{real_clean: clean};
say q{	rm -rf s/en-words.js s/ar-words.js};
say q{};
say q{clean:};
say q{	rm -rf s/ltr-style.css index.html } . join ' ', map { "$_/index.html" } @all;
say q{};
say q{update:};
say q{	$(PL) .p/makegen.pl > Makefile};
say q{};

say ".PHONEY: update real_clean clean @all";

