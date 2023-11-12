all: Makefile index.html arak dv-ar dvorak ibm-ar

Makefile: .p/makegen.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmakegen[m"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mMakefile[m"
	@perl -CDAS -Mutf8 .p/makegen.pl > Makefile

arak: arak/index.html
arak/index.html: .p/* arak/.?? arak/.mapping.min.js s/ar-words.js s/ar.min.js s/style.min.css .p/html-minify.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96m<[m .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/arabic.ini keyboard=arak title='أراك — مدرب لوحات المفاتيح'"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mhash-for-cache[m arak"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mminifier[m html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmkkeyboard[m arak/.kb"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m arak/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmapping[m arak"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92marak/index.html[m"
	@cat .p/html.html | perl -CDAS -Mutf8 .p/applyini.pl .p/arabic.ini keyboard=arak title='أراك — مدرب لوحات المفاتيح' | perl -CDAS -Mutf8 .p/hash-for-cache.pl arak | perl -CDAS -Mutf8 .p/minifier.pl html | tr -d '\n' | perl -CDAS -Mutf8 .p/mkkeyboard.pl arak/.kb | perl -CDAS -Mutf8 .p/mklessons.pl arak/.ls | perl -CDAS -Mutf8 .p/mapping.pl arak > arak/index.html

dv-ar: dv-ar/index.html
dv-ar/index.html: .p/* dv-ar/.?? dv-ar/.mapping.min.js s/ar-words.js s/ar.min.js s/style.min.css .p/html-minify.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96m<[m .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/arabic.ini keyboard=dv-ar title='لوحة دڤوراك العربية الصوتية (تجريبية) — مدرب لوحات المفاتيح'"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mhash-for-cache[m dv-ar"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mminifier[m html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmkkeyboard[m dv-ar/.kb"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m dv-ar/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmapping[m dv-ar"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mdv-ar/index.html[m"
	@cat .p/html.html | perl -CDAS -Mutf8 .p/applyini.pl .p/arabic.ini keyboard=dv-ar title='لوحة دڤوراك العربية الصوتية (تجريبية) — مدرب لوحات المفاتيح' | perl -CDAS -Mutf8 .p/hash-for-cache.pl dv-ar | perl -CDAS -Mutf8 .p/minifier.pl html | tr -d '\n' | perl -CDAS -Mutf8 .p/mkkeyboard.pl dv-ar/.kb | perl -CDAS -Mutf8 .p/mklessons.pl dv-ar/.ls | perl -CDAS -Mutf8 .p/mapping.pl dv-ar > dv-ar/index.html

ibm-ar: ibm-ar/index.html
ibm-ar/index.html: .p/* ibm-ar/.?? ibm-ar/.mapping.min.js s/ar-words.js s/ar.min.js s/style.min.css .p/html-minify.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96m<[m .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/arabic.ini keyboard=ibm-ar title='لوحة المفاتيح العربية الشائعة (IBM) — مدرب لوحات المفاتيح'"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mhash-for-cache[m ibm-ar"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mminifier[m html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmkkeyboard[m ibm-ar/.kb"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m ibm-ar/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmapping[m ibm-ar"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mibm-ar/index.html[m"
	@cat .p/html.html | perl -CDAS -Mutf8 .p/applyini.pl .p/arabic.ini keyboard=ibm-ar title='لوحة المفاتيح العربية الشائعة (IBM) — مدرب لوحات المفاتيح' | perl -CDAS -Mutf8 .p/hash-for-cache.pl ibm-ar | perl -CDAS -Mutf8 .p/minifier.pl html | tr -d '\n' | perl -CDAS -Mutf8 .p/mkkeyboard.pl ibm-ar/.kb | perl -CDAS -Mutf8 .p/mklessons.pl ibm-ar/.ls | perl -CDAS -Mutf8 .p/mapping.pl ibm-ar > ibm-ar/index.html

dvorak: dvorak/index.html
dvorak/index.html: .p/* dvorak/.?? dvorak/.mapping.min.js s/en-words.js s/en.min.js s/ltr-style.min.css .p/html-minify.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96m<[m .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/english.ini keyboard=dvorak title='Dvorak (DSK) — Keyboard Trainer'"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mhash-for-cache[m dvorak"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mminifier[m html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmkkeyboard[m dvorak/.kb"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m dvorak/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmapping[m dvorak"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mdvorak/index.html[m"
	@cat .p/html.html | perl -CDAS -Mutf8 .p/applyini.pl .p/english.ini keyboard=dvorak title='Dvorak (DSK) — Keyboard Trainer' | perl -CDAS -Mutf8 .p/hash-for-cache.pl dvorak | perl -CDAS -Mutf8 .p/minifier.pl html | tr -d '\n' | perl -CDAS -Mutf8 .p/mkkeyboard.pl dvorak/.kb | perl -CDAS -Mutf8 .p/mklessons.pl dvorak/.ls | perl -CDAS -Mutf8 .p/mapping.pl dvorak > dvorak/index.html

index.html: .p/home.html .p/mkhome.pl s/main-style.min.css */.info .p/html-minify.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmkhome[m .p/home.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mhash-for-cache[m ."
	@printf "\e[93m%s\e[m %s\n" "|" "[96mminifier[m html"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mindex.html[m"
	@perl -CDAS -Mutf8 .p/mkhome.pl .p/home.html | perl -CDAS -Mutf8 .p/hash-for-cache.pl . | perl -CDAS -Mutf8 .p/minifier.pl html | tr -d '\n' > index.html

s/ltr-style.css: s/style.css
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mflipdirection[m s/style.css"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92ms/ltr-style.css[m"
	@perl -CDAS -Mutf8 .p/flipdirection.pl s/style.css > s/ltr-style.css

s/%.min.css: s/%.css .p/minifier.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mminifier[m css "$<""
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92m"$@"[m"
	@perl -CDAS -Mutf8 .p/minifier.pl css "$<" > "$@"

%/.mapping.min.js: %/.mapping.js .p/minifier.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mminifier[m js "$<""
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92m"$@"[m"
	@perl -CDAS -Mutf8 .p/minifier.pl js "$<" > "$@"

s/%.min.js: s/%[^.]?*.js s/javascript.js .p/minifier.pl
	@printf "\e[93m%s\e[m %s\n" "$$" "[96m<[m "$<" s/javascript.js"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mminifier[m js"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92m"$@"[m"
	@cat "$<" s/javascript.js | perl -CDAS -Mutf8 .p/minifier.pl js | tr -d '\n' > "$@"

s/ar-words.js: .w/voweled-imlaai-quran-words
	# based on WikiSource Voweled Imalaai Quran Text
	# # the 3rd s-cmd in the 1st sed to move the shadda before the other vowel, b/c wikisource always puts it after the vowel.
	# sed 's/([0-9]\+)//g; s/ \+/\n/g; s/\(.\)ّ/ّ\1/g' quran | sort -u | grep -v ^$$ > voweled-imlaai-quran-words
	< "$<" sed 's/^/"/; s/$$/",/' | sed -ne '1ivar FULL_WORDS=[' -e 'p;$$i]' | tr -d '\n' > "$@"

s/en-words.js: .w/xkcd-simple-writer-words
	# based on XKCD Simple Writer Word List 0.2.1
	< "$<" sed 's/^/"/; s/$$/",/' | sed -ne '1ivar FULL_WORDS=[' -e 'p;$$i]' | tr -d '\n' > "$@"

real_clean: clean
	rm -rf s/en-words.js s/ar-words.js

clean:
	rm -rf s/ltr-style.css s/*style.min.css index.html */.mapping.min.js */index.html

update:
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmakegen[m"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mMakefile[m"
	@perl -CDAS -Mutf8 .p/makegen.pl > Makefile

.PHONEY: update real_clean clean arak dv-ar dvorak ibm-ar
