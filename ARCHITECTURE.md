# Keyboard Trainer (KBT)

- `Makefile`: start by regenerating it by running `make update` (or see `makegen.pl` under `.p/` below).
  Then run it without argument to generate everything.

## Processing (`.p/`)

- `applyini.pl`: applies the localization to the html.
- `flipdirection.pl`: flips the text direction of html or css.
- `mkkeyboard.pl`
- `mklessons.pl`
- `arabic.ini`: Arabic localization for `html.html`.
- `english.ini`: English localization for `html.html`.
- `html.html`: our html template.
- `makegen.pl`: call it as `.p/makegen.pl > Makefile` when you add or remove a keyboard.

## Static (`s/`)

### Static statics:

- `arabic.js`
- `english.js`
- `javascript.js`
- `style.css`
- `test.js`
- `KawkabMono-Bold-subset-scaled.woff2`, and
- `KawkabMono-Regular-subset-scaled.woff2`:
  Beautiful monowidth Arabic font; <https://makkuk.com/kawkab-mono/>; OFL-1.1; all non-Arabic glyphs removed; and scaled 75%.

### Generated statics:

- `ar-words.js`: generated from `.r` via `Makefile`.
- `en-words.js`: generated from `.r` via `Makefile`.
- `ltr-style.css`: generated from `style.css` by `.p/flipdirection.pl` via `Makefile`.

## Resources (`.w/`)

The words.

The Arabic words are based on WikiSource Voweled Imalaai Quran Text.

The English words are based on XKCD Simple Writer Word List 0.2.1.

## Keyboards (`arak/`, `dvorak/`, etc)

- `.kb`: the keyboard itself.
- `.ls`: the lessons in a custom language.
- `mapping.js`: an object mapping KeyboardEvent.code to [normalChar, shiftedChar], for emulation. See <https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code> and <https://developer.mozilla.org/en-US/docs/Web/API/UI_Events/Keyboard_event_code_values>.

## Hidden Keyboards (`.qwerty/`, `.mac/`)

Like Keyboards above, but incomplete, as they exist primarily for development reasons.