all: index.html arak dv-ar dvorak ibm-ar

arak: arak/index.html
arak/index.html: .p/* arak/.?? arak/mapping.js s/ar-words.js
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmkkeyboard[m arak/.kb .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m arak/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/arabic.ini keyboard=arak title='أراك — مدرب لوحات المفاتيح'"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92marak/index.html[m"
	@perl -CDAS -Mutf8 .p/mkkeyboard.pl arak/.kb .p/html.html | perl -CDAS -Mutf8 .p/mklessons.pl arak/.ls | perl -CDAS -Mutf8 .p/applyini.pl .p/arabic.ini keyboard=arak title='أراك — مدرب لوحات المفاتيح' > arak/index.html

dv-ar: dv-ar/index.html
dv-ar/index.html: .p/* dv-ar/.?? dv-ar/mapping.js s/ar-words.js
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmkkeyboard[m dv-ar/.kb .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m dv-ar/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/arabic.ini keyboard=dv-ar title='لوحة دڤوراك العربية الصوتية (تجريبية) — مدرب لوحات المفاتيح'"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mdv-ar/index.html[m"
	@perl -CDAS -Mutf8 .p/mkkeyboard.pl dv-ar/.kb .p/html.html | perl -CDAS -Mutf8 .p/mklessons.pl dv-ar/.ls | perl -CDAS -Mutf8 .p/applyini.pl .p/arabic.ini keyboard=dv-ar title='لوحة دڤوراك العربية الصوتية (تجريبية) — مدرب لوحات المفاتيح' > dv-ar/index.html

ibm-ar: ibm-ar/index.html
ibm-ar/index.html: .p/* ibm-ar/.?? ibm-ar/mapping.js s/ar-words.js
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmkkeyboard[m ibm-ar/.kb .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m ibm-ar/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/arabic.ini keyboard=ibm-ar title='لوحة المفاتيح العربية الشائعة (IBM) — مدرب لوحات المفاتيح'"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mibm-ar/index.html[m"
	@perl -CDAS -Mutf8 .p/mkkeyboard.pl ibm-ar/.kb .p/html.html | perl -CDAS -Mutf8 .p/mklessons.pl ibm-ar/.ls | perl -CDAS -Mutf8 .p/applyini.pl .p/arabic.ini keyboard=ibm-ar title='لوحة المفاتيح العربية الشائعة (IBM) — مدرب لوحات المفاتيح' > ibm-ar/index.html

dvorak: dvorak/index.html
dvorak/index.html: .p/* dvorak/.?? dvorak/mapping.js s/en-words.js s/ltr-style.css
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmkkeyboard[m dvorak/.kb .p/html.html"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mmklessons[m dvorak/.ls"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mflipdirection[m"
	@printf "\e[93m%s\e[m %s\n" "|" "[96mapplyini[m .p/english.ini keyboard=dvorak title='Dvorak (DSK) — Keyboard Trainer'"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mdvorak/index.html[m"
	@perl -CDAS -Mutf8 .p/mkkeyboard.pl dvorak/.kb .p/html.html | perl -CDAS -Mutf8 .p/mklessons.pl dvorak/.ls | perl -CDAS -Mutf8 .p/flipdirection.pl | perl -CDAS -Mutf8 .p/applyini.pl .p/english.ini keyboard=dvorak title='Dvorak (DSK) — Keyboard Trainer' > dvorak/index.html

index.html: .p/home.html .p/mkhome.pl */.info
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmkhome[m .p/home.html"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mindex.html[m"
	@perl -CDAS -Mutf8 .p/mkhome.pl .p/home.html > index.html

s/ltr-style.css: s/style.css
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mflipdirection[m s/style.css"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92ms/ltr-style.css[m"
	@perl -CDAS -Mutf8 .p/flipdirection.pl s/style.css > s/ltr-style.css

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
	@printf "\e[93m%s\e[m %s\n" "$$" "[96mmakegen[m"
	@printf "\e[93m%s\e[m %s\n" ">" "[1;92mMakefile[m"
	@perl -CDAS -Mutf8 .p/makegen.pl > Makefile

.PHONEY: update real_clean clean arak dv-ar dvorak ibm-ar
