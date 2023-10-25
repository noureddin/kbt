$homekeys = 'روالنميه'
$homerow = $homekeys + 'إتف'
$allletters = 'إروؤاءلتثفنميهجكأآدخسحبعغضطظزىئةذصقش'
$vowels_1 = '\N{ARABIC FATHA}\N{ARABIC KASRA}\N{ARABIC DAMMA}\N{ARABIC SHADDA}'
$vowels_2 = '\N{ARABIC FATHATAN}\N{ARABIC KASRATAN}\N{ARABIC DAMMATAN}\N{ARABIC SUKUN}'
$vowels_all = $vowels_1 + $vowels_2

1 > $homekeys               > ١) أحرف الارتكاز الثمانية
2 > $homerow                > ٢) صف الارتكاز بالكامل
3 > $homerow+$$             > ٣) صف الارتكاز + ج ك أ د س ق ع ب
4 > $homerow+$$             > ٤) صف الارتكاز + ط ز ى ذ ث ص ح ش
5 > $homerow+$$             > ٥) صف الارتكاز + ظ ؤ ء ئ ة آ خ ض غ
6 > $allletters             > ٦) جميع الحروف العربية
7 > $allletters+$vowels_1   > ٧) جميع الحروف العربية والفتحة والضمة والكسرة والشدة
8 > $allletters+$vowels_all > ٨) جميع الحروف العربية والسكون والتنوين
9 > $allletters+$vowels_all > ٩) جميع الحروف العربية وجميع علامات التشكيل

; the last lesson is intentionally repeated twice; that way lesson 8 gives you
; practice on the new vowels, before practicing them all in lesson 9.
