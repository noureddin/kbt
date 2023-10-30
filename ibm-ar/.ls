$homekeys = 'كمنتشسيب'
$homerow = $homekeys + 'طال'
$allletters = 'إروؤاءلتثفنميهجكأآدخسحبعغضطظزىئةذصقش'
$vowels = 'ًٌٍَُِّْ'
; $vowels contains the Arabic zero-width vowel marks

1 > $homekeys           > ١) أحرف الارتكاز الثمانية
2 > $homerow            > ٢) صف الارتكاز بالكامل بغير العالي
3 > $homerow+$$         > ٣) صف الارتكاز + ج ز و ه&zwj; غ أ ف ء ض
4 > $homerow+$$         > ٤) صف الارتكاز + د خ ة ى إ ر ق ؤ
5 > $homerow+$$         > ٥) صف الارتكاز + ظ ح ع آ ث ص ئ ذ
6 > $allletters         > ٦) جميع الحروف العربية
7 > $allletters+$vowels > ٧) جميع الحروف العربية وجميع علامات التشكيل
