#!/usr/bin/env perl
use v5.14; use warnings; use autodie; use utf8;
use open qw[ :encoding(UTF-8) :std ];

# grep dirs that has both .mapping.js & .ls
my @all = map { -e s,/.*$,/.ls,r ? s,/.*,,r : () } glob '*/.mapping.js';

my @ar = grep { 0==system('grep', '-q', 'ب', "$_/.mapping.js") } @all;
my @en = grep { 0!=system('grep', '-q', 'ب', "$_/.mapping.js") } @all;

say "all: Makefile index.html @all";
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

sub _color_cmd { my $c = shift; join ' ', "\e[96m".($c ? $c : '<')."\e[m", @_ }

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
      join ' ', ($cmd ? "perl -CDAS -Mutf8 .p/$cmd.pl" : 'cat'), @$_
    } @_)
    =~ s,(\Q | perl -CDAS -Mutf8 .p/minifier.pl \E[^|>]*),$1| tr -d '\\n' ,gr
    # strip newlines after minification, because uglifyjs ends files with them
}

say 'Makefile: .p/makegen.pl';
say pipeline
  ['makegen'],
    'Makefile';

for my $ar (@ar) {
  my $title = read_name($ar).' — مدرب لوحات المفاتيح';
  say "$ar: $ar/index.html";
  say "$ar/index.html: .p/* $ar/.?? $ar/.mapping.min.js s/ar-words.js s/ar.min.js s/style.min.css .p/html-minify.pl";
  say pipeline
    ['' => ".p/html.html"],
    ['applyini' => ".p/arabic.ini", "keyboard=$ar", "title='$title'"],
    ['hash-for-cache' => $ar],
    ['mkkb'],
    ['minifier' => 'html'],
    ['mklessons' => "$ar/.ls"],
    ['mapping' => $ar],
      "$ar/index.html";
}

for my $en (@en) {
  my $title = read_name($en).' — Keyboard Trainer';
  say "$en: $en/index.html";
  say "$en/index.html: .p/* $en/.?? $en/.mapping.min.js s/en-words.js s/en.min.js s/ltr-style.min.css .p/html-minify.pl";
  say pipeline
    ['' => ".p/html.html"],
    ['applyini' => ".p/english.ini", "keyboard=$en", "title='$title'"],
    ['hash-for-cache' => $en],
    ['mkkb'],
    ['minifier' => 'html'],
    ['mklessons' => "$en/.ls"],
    ['mapping' => $en],
      "$en/index.html";
}

say 'index.html: .p/home.html .p/mkhome.pl s/main-style.min.css */.info .p/html-minify.pl';
say pipeline
  ['mkhome' => '.p/home.html'],
  ['hash-for-cache' => '.'],
  ['minifier' => 'html'],
    'index.html';

say 's/ltr-style.css: s/style.css';
say pipeline [flipdirection => 's/style.css'], 's/ltr-style.css';

say 's/%.min.css: s/%.css .p/minifier.pl';
say pipeline [minifier => 'css', '"$<"'], '"$@"';

say '%/.mapping.min.js: %/.mapping.js .p/minifier.pl';
say pipeline [minifier => 'js', '"$<"'], '"$@"';

say 's/%.min.js: s/%[^.]?*.js s/javascript.js .p/minifier.pl';
say pipeline
  ['' => '"$<"', 's/javascript.js'],  # concatenate lang-specific js with the common one
  # ['minifier' => 'js'],
    '"$@"';

say 's/ar-words.js: .w/voweled-imlaai-quran-words';
say "\t", q{# based on WikiSource Voweled Imalaai Quran Text};
say "\t", q{# # the 3rd s-cmd in the 1st sed to move the shadda before the other vowel, b/c wikisource always puts it after the vowel.};
say "\t", q{# sed 's/([0-9]\+)//g; s/ \+/\n/g; s/\(.\)ّ/ّ\1/g' quran | sort -u | grep -v ^$$ > voweled-imlaai-quran-words};
say "\t", q{< "$<" sed 's/^/"/; s/$$/",/' | sed -ne '1ivar FULL_WORDS=[' -e 'p;$$i]' | tr -d '\n' > "$@"};
say '';

say 's/en-words.js: .w/xkcd-simple-writer-words';
say "\t", q{# based on XKCD Simple Writer Word List 0.2.1};
say "\t", q{< "$<" sed 's/^/"/; s/$$/",/' | sed -ne '1ivar FULL_WORDS=[' -e 'p;$$i]' | tr -d '\n' > "$@"};
say '';

say 'real_clean: clean';
say "\t", q{rm -rf s/en-words.js s/ar-words.js};
say '';

say 'clean:';
say "\t", q{rm -rf s/ltr-style.css s/*style.min.css index.html */.mapping.min.js */index.html};
say '';

say 'update:';
say pipeline ['makegen'], 'Makefile';

say ".PHONEY: update real_clean clean @all";

