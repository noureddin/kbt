PL=perl -CDAS -mutf8

all: index.html arak dv-ar dvorak ibm-ar

arak: arak/index.html
arak/index.html: .p/* arak/.?? s/ar-words.js
	$(PL) .p/mkkeyboard.pl arak/.kb .p/html.html | $(PL) .p/mklessons.pl arak/.ls | $(PL) .p/applyini.pl .p/arabic.ini keyboard=arak title='أراك — مدرب لوحات المفاتيح' > arak/index.html

dv-ar: dv-ar/index.html
dv-ar/index.html: .p/* dv-ar/.?? s/ar-words.js
	$(PL) .p/mkkeyboard.pl dv-ar/.kb .p/html.html | $(PL) .p/mklessons.pl dv-ar/.ls | $(PL) .p/applyini.pl .p/arabic.ini keyboard=dv-ar title='لوحة دڤوراك العربية الصوتية (تجريبي) — مدرب لوحات المفاتيح' > dv-ar/index.html

ibm-ar: ibm-ar/index.html
ibm-ar/index.html: .p/* ibm-ar/.?? s/ar-words.js
	$(PL) .p/mkkeyboard.pl ibm-ar/.kb .p/html.html | $(PL) .p/mklessons.pl ibm-ar/.ls | $(PL) .p/applyini.pl .p/arabic.ini keyboard=ibm-ar title='لوحة المفاتيح العربية الشائعة (IBM) — مدرب لوحات المفاتيح' > ibm-ar/index.html

dvorak: dvorak/index.html
dvorak/index.html: .p/* dvorak/.?? s/en-words.js s/ltr-style.css
	$(PL) .p/mkkeyboard.pl dvorak/.kb .p/html.html | $(PL) .p/mklessons.pl dvorak/.ls | $(PL) .p/flipdirection.pl | $(PL) .p/applyini.pl .p/english.ini keyboard=dvorak title='Dvorak (DSK) — Keyboard Trainer' > dvorak/index.html
	sed 's|/style.css"|/ltr-style.css"|' -i dvorak/index.html

index.html: .p/home.html .p/mkhome.pl */.info
	$(PL) .p/mkhome.pl .p/home.html > index.html

s/ltr-style.css: s/style.css
	$(PL) .p/flipdirection.pl s/style.css > s/ltr-style.css

s/ar-words.js:
	# based on WikiSource Voweled Imalaai Quran Text
	# # the 3rd s-cmd in the 1st sed to move the shadda before the other vowel, b/c wikisource always puts it after the vowel.
	# sed 's/([0-9]\+)//g; s/ \+/\n/g; s/\(.\)ّ/ّ\1/g' quran | sort -u | grep -v ^$$ > voweled-imlaai-quran-words
	<.w/voweled-imlaai-quran-words sed 's/^/"/; s/$$/",/' | sed -ne '1iconst FULL_WORDS = [' -e 'p;$$i]' > s/ar-words.js

s/en-words.js:
	# based on XKCD Simple Writer Word List 0.2.1
	<.w/xkcd-simple-writer-words sed 's/^/"/; s/$$/",/' | sed -ne '1iconst FULL_WORDS = [' -e 'p;$$i]' > s/en-words.js

real_clean: clean
	rm -rf s/en-words.js s/ar-words.js

clean:
	rm -rf s/ltr-style.css index.html arak/index.html dv-ar/index.html dvorak/index.html ibm-ar/index.html

update:
	$(PL) .p/makegen.pl > Makefile

.PHONEY: update real_clean clean arak dv-ar dvorak ibm-ar
