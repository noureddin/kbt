#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

# grep dirs that has both .kb & .ls
my @all = map { -e s,..$,ls,r ? s,.{4}$,,r : () } glob '*/.kb';

my @ar = grep { 0==system('grep', '-q', 'ب', "$_/.kb") } @all;
my @en = grep { 0!=system('grep', '-q', 'ب', "$_/.kb") } @all;

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

sub _color_cmd { join ' ', "\e[96m".shift."\e[m", @_ }

sub pipeline {
  my $output = pop;
  return
  (join "\n",
    (sprintf "\t".'@printf "\e[93m%%s\e[m %%s\n" "$$" "%s"', _color_cmd @{$_[0]}),
    (map {
      sprintf "\t".'@printf "\e[93m%%s\e[m %%s\n" "|" "%s"', _color_cmd @$_
    } @_[1..$#_]),
    (sprintf "\t".'@printf "\e[93m%%s\e[m %%s\n" ">" "%s"', "\e[1;92m$output\e[m"),
  ).
  sprintf("\n\t\@%s > $output\n",
    join ' | ',
    map {
      my $cmd = shift @$_;
      join ' ', "perl -CDAS -Mutf8 .p/$cmd.pl", @$_
    } @_)
}

for my $ar (@ar) {
  my $title = read_name($ar).' — مدرب لوحات المفاتيح';
  say "$ar: $ar/index.html";
  say "$ar/index.html: .p/* $ar/.?? $ar/mapping.js s/ar-words.js s/*";
  say pipeline
    ['mkkeyboard' => "$ar/.kb", ".p/html.html"],
    ['mklessons' => "$ar/.ls"],
    ['rmcomments'],
    ['applyini' => ".p/arabic.ini", "keyboard=$ar", "title='$title'"],
    ['hash-for-cache' => $ar],
      "$ar/index.html";
}

for my $en (@en) {
  my $title = read_name($en).' — Keyboard Trainer';
  say "$en: $en/index.html";
  say "$en/index.html: .p/* $en/.?? $en/mapping.js s/en-words.js s/ltr-style.css s/*";
  say pipeline
    ['mkkeyboard' => "$en/.kb", ".p/html.html"],
    ['mklessons' => "$en/.ls"],
    ['rmcomments'],
    ['flipdirection'],  # also changes loading style.css to ltr-style.css
    ['applyini' => ".p/english.ini", "keyboard=$en", "title='$title'"],
    ['hash-for-cache' => $en],
      "$en/index.html";
}

say q{index.html: .p/home.html .p/mkhome.pl s/* */.info};
say pipeline
  [mkhome => '.p/home.html'],
  ['rmcomments'],
  ['hash-for-cache' => '.'],
    'index.html';

say q{s/ltr-style.css: s/style.css};
say pipeline [flipdirection => 's/style.css'], 's/ltr-style.css';

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
say pipeline ['makegen'], 'Makefile';

say ".PHONEY: update real_clean clean @all";

