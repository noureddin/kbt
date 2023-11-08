# Keyboard Trainer (KBT)

- `Makefile`: start by regenerating it by running `make update` (or see `makegen.pl` under `.p/` below).
  Then run it without argument to generate everything.

## Processing (`.p/`)

### Data:

- `home.html`: homepage template.
- `html.html`: html template for the keyboard lessons.
- `arabic.ini`: Arabic localization for `html.html`.
- `english.ini`: English localization for `html.html`.

### Scripts:

1. `makegen.pl`: generates the Makefile; call it as `.p/makegen.pl > Makefile` when you add or remove or rename a keyboard.
2. `mkhome.pl`: generates the homepage.
3. `mkkeyboard.pl`: parses the keyboard and inserts it properly in the html template.
4. `mklessons.pl`: parses the lessons and inserts them properly in the html template.
5. `rmcomments.pl`: removes four-hyphen html comments (ie, those starting with `<!----`).
6. `flipdirection.pl`: flips the horizontal direction of html or css.
7. `applyini.pl`: applies the localization to the html.
8. `hash-for-cache.pl`: adds a unique querystring to static resources for cache-busting on change.

## Static (`s/`)

### Static statics:

- `arabic.js`: Arabic-specific definitions and messages.
- `english.js`: English-specific definitions and messages.
- `javascript.js`: basically all of the business logic.
- `main-style.css`: CSS for the homepage only.
- `style.css`: CSS for the Arabic lessons pages (see also `ltr-style.css` below).
- `test.js`: some sanity checks.
- `KawkabMono-Bold-subset-scaled.woff2`, and
- `KawkabMono-Regular-subset-scaled.woff2`:
  Beautiful monowidth Arabic font; <https://makkuk.com/kawkab-mono/>; OFL-1.1; scaled 75%, and all non-Arabic glyphs removed.

### Generated statics:

- `ar-words.js`: an array of all our Arabic words; generated from `.w` via `Makefile`.
- `en-words.js`: an array of all our English words; generated from `.w` via `Makefile`.
- `ltr-style.css`: CSS for the English lessons pages; generated from `style.css` by `.p/flipdirection.pl` via `Makefile`.

## Resources (`.w/`)

The words.

The Arabic words are based on <a href="https://ar.wikisource.org/wiki/القرآن_الكريم_(بالرسم_الإملائي)/النص_المشكول">WikiSource Voweled Imalaai Quran Text</a>

The English words are based on [XKCD Simple Writer Word List 0.2.1](https://xkcd.com/simplewriter/).

## Keyboards (`arak/`, `dvorak/`, etc)


- `.kb`: the layout itself.
- `.ls`: the lessons in a custom language.
- `.info`: some metadata; currently only the human-friendly name of the layout.
- `.mapping.js`: an object mapping `KeyboardEvent.code` to `[normalChar, shiftedChar]`, for emulation. See [`KeyboardEvent.code`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code) and [Keyboard event code values](https://developer.mozilla.org/en-US/docs/Web/API/UI_Events/Keyboard_event_code_values) on MDN.

## Hidden Keyboards (`.qwerty/`, `.mac-ar/`)

Like Keyboards above, but incomplete, as they exist primarily for development reasons.
