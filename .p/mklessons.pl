#!/usr/bin/env perl
# vim: fdm=marker :
use v5.14; use warnings; use autodie; use utf8;
use open qw( :encoding(UTF-8) :std );
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';

sub _read_var { my ($x) = @_;
  return $x =~ /^(\$\$|\$\p{ID_Start}\p{ID_Continue}*)\h*(.*)$/;
}

sub _read_str { my ($x) = @_;
  my ($delim, $str, $expr) = $x =~ /^(['"])([^\1]+?)\1\h*(.*)$/;
  $str =~ s/\\N\{.*?\}/eval(qq("$&"))/ge;
  return $str, $expr;
}

sub _decode { my ($html) = @_;
  return $html
    =~ s|&zwj;|\N{ZWJ}|gr
}

sub eval_expr { my ($expr, $env) = @_;
  my $value = '';
  $expr =~ s/^\h*//;
  until ($expr eq '') {
    if ($expr =~ /^\$/) {
      (my $var, $expr) = _read_var $expr;
      $value .= $env->{$var}
    }
    elsif ($expr =~ /^['"]/) {
      (my $str, $expr) = _read_str $expr;
      $value .= $str;
    }
    elsif ($expr =~ /^\+/) {
      $expr =~ s/\+\h*//;
    }
    else {
      die "Unrecognizable expression: $expr\n"
    }
  }
  return $value;
}

sub get_this { my ($title) = @_;
  return lc $title =~ s/^.*?\+//gr =~ s/[\h\N{ZWJ}]*//gr;
}

sub read_lessons { my ($lessonsfile) = @_;
  my %defs;
  my $html;
  my @ltrs;
  my $i = 1;
  open my $input_lessons_fh, '<', $lessonsfile;
  while (<$input_lessons_fh>) {
    if (/^\s*$/ || /^\h*;/) { next }
    elsif (/^(\$\p{ID_Start}\p{ID_Continue}*)\h*=\h*(.*)\h*$/) {
      # say "\e[90msetting\e[m $1 \e[90mto the value of\e[m $2"
      my ($name, $val) = ($1, $2);
      if (exists $defs{$name}) { warn "Redefining $name at line $.\n" }
      $defs{$name} = eval_expr $val, \%defs;
    }
    elsif (/^ \h* ([0-9]+) \h*>\h* (.*?) \h*>\h* (.*?) \h*$/x) {
      # say "lesson $1 has the value of $2 and the title of $3"
      my ($num, $val, $title) = ($1, $2, $3);
      if ($num != $i) {
          die "Lessons must start with 1 and continue consecutively; found lesson $num\n"
      }
      ++$i;
      $title = _decode $title;
      if ($val =~ /\$\$/ && $title !~ /\+/) { die "\$\$ wanted but found no '+' in lesson $num at line $.\n" }
      my $this = $val =~ /\$\$/? get_this($title) : '';
      my $letters = eval_expr $val, {%defs, '$$' => $this};
      $html .= sprintf '<option value=%d%s>%s</option>', $num, $num==1?' selected':'', $title;
      push @ltrs, $letters;
    }
    else {
      warn "unrecognized instruction at line $.: $_\n"
    }
  }
  close $input_lessons_fh;
  my $js = sprintf 'var L="%s"', join ' ', @ltrs;
  # NOTE: $js assumes " is not used; but ' is okay
  return $html, $js;
}

sub main {
  my $lessonsfile = shift @ARGV;
  my ($html, $js) = read_lessons $lessonsfile;
  while (<>) {
    s|<<lessons>>|$html|;
    s|<<lessons_js>>|$js|;
    print;
  }
}


unless (@ARGV && $ARGV[0] eq 'test') { main; exit }

use Test::More;

subtest 'test _read_var' => sub {
  for my $e (
    ['$x+$y', '$x', '+$y'],
    ['$x + $y', '$x', '+ $y'],
    ['$x + "y"', '$x', '+ "y"'],
    ['$x++', '$x', '++'],
  ) {
    is_deeply [_read_var($e->[0])], [$e->@[1,2]], $e->[0];
  }
  done_testing;
};

subtest 'test _read_str' => sub {
  for my $e (
    [q['x' + $y], q[x], q[+ $y]],
    [q["x" + $y], q[x], q[+ $y]],
    [q["\N{COLON}" + $y], q[:], q[+ $y]],
    [q["\N{ARABIC LETTER BEH}" + $y], q[ب], q[+ $y]],
  ) {
    is_deeply [_read_str($e->[0])], [$e->@[1,2]], $e->[0];
  }
  done_testing;
};

subtest 'test eval_expr' => sub {
  for my $e (
    [q['x'], {}, q[x]],
    [q['x' + 'y'], {}, q[xy]],
    [q['x' + $home], {'$home'=>'y'}, q[xy]],
    [q['x' + $$], {'$$'=>'y'}, q[xy]],
    [q['x'+$$], {'$$'=>'y'}, q[xy]],
    [q[$home+$$], {'$home'=>'x','$$'=>'y'}, q[xy]],
    [q['a'+$home+$$], {'$home'=>'x','$$'=>'y'}, q[axy]],
  ) {
    is eval_expr($e->@[0,1]), $e->[2], $e->[0];
  }
  done_testing;
};

done_testing;

