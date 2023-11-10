const WORDS = FULL_WORDS
    .map(w => w.replace(/[ًٌٍَُِّْ]/g,''))  // remove vowel marks
    .filter((e, i, a) => e !== a[i-1])  // uniq

const want_full_words = (letters) => letters.match(/[ًٌٍَُِّْ]/)

const WORDS_LIMIT = 100
const FULL_WORDS_LIMIT = Math.round(WORDS_LIMIT / 2)

const lessons_ordinal = ['الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس', 'السادس', 'السابع', 'الثامن', 'الأخير'].map(e => 'الدرس&ensp;'+e)

const TXT_ENTER_ALERT = 'اضغط زر المسافة بعد كل كلمة، فهو أسرع، وهو المعتاد'

const BAD_LEFT_SHIFT_ALERT = 'استخدم زر العالي الأيمن مع الأزرار التي على يسار اللوحة'
const BAD_RIGHT_SHIFT_ALERT = 'استخدم زر العالي الأيسر مع الأزرار التي على يمين اللوحة'

// Round to arbitrary precision
const round_int = (e,p) => p ? Math.round(e * 10**p) / 10**p : Math.round(e)

const format_int = (n) => n.toString()
    .replace(/0/g,'٠').replace(/1/g,'١').replace(/2/g,'٢').replace(/3/g,'٣').replace(/4/g,'٤')
    .replace(/5/g,'٥').replace(/6/g,'٦').replace(/7/g,'٧').replace(/8/g,'٨').replace(/9/g,'٩')
const parse_int = (n) => +n
    .replace(/٠/g,'0').replace(/١/g,'1').replace(/٢/g,'2').replace(/٣/g,'3').replace(/٤/g,'4')
    .replace(/٥/g,'5').replace(/٦/g,'6').replace(/٧/g,'7').replace(/٨/g,'8').replace(/٩/g,'9')
const format_plural_word = (n, ws) => format_int(n) + ' ' + (
    n === 0 ? ws[0] :
    n === 1 ? ws[1] :
    n === 2 ? ws[2] :
    n % 100 === 0 ? ws[5] :
    n % 100 < 11 ? ws[3] :
        ws[4]
) // ws is 0, 1, 2 (-iin), 3-10 [3], 11-99 [4], 100x [5]

const ws_letters = ['حرف', 'حرف', 'حرفين', 'أحرف', 'حرفًا', 'حرف']
const ws_words = ['كلمة', 'كلمة', 'كلمتين', 'كلمات', 'كلمة', 'كلمة']
const ws_minutes = ['دقيقة', 'دقيقة', 'دقيقتين', 'دقائق', 'دقيقة', 'دقيقة']
const ws_seconds = ['ثانية', 'ثانية', 'ثانيتين', 'ثوانٍ', 'ثانية', 'ثانية']

// the first line in the finish msg; gives wpm and/or cpm, accuracy, and possibly other stats.
const finish_msg_init = (cpm, wpm, len, sec, acc, lesson) =>
    format_plural_word(round_int(cpm), ws_letters) + ' في الدقيقة (' +
    format_int(round_int(wpm)) + ' ك/د بصحة ' + format_int(round_int(acc)) + '٪).'

// the second line in the finish msg, if there are more lessons.
const finish_msg_forward = (cpm, wpm, len, sec, acc, wrong_chars, lesson) => '<br>'
    + 'تقدم إلى ' + lesson_link(lesson + 1) + ' أو أعد ' + lesson_link(lesson) + '.'

// the second line in the finish msg, if it's the last lesson.
const finish_msg_end = (cpm, wpm, len, sec, acc, wrong_chars, lesson) => '<br>'
    + 'لقد أنهيت جميع الدروس! يمكنك الانطلاق، أو إعادة ' + lesson_link(lesson) + '.'

// additional line in the finish msg, if the accuracy is bad.
const finish_msg_repeat = (cpm, wpm, len, sec, acc, wrong_chars, lesson) => '<br>'
    + 'ولكن بهذه الصحة القليلة، الأفضل أن تعيد ' + lesson_link(lesson) + '.'

// const finish_msg = (cpm, wpm, len, sec, acc, lesson) => (
//     format_plural_word(round_int(cpm), ws_letters) + ' في الدقيقة (' +
//     // format_int(round_int(wpm)) + ' ك/د)<br>(' +
//     format_int(round_int(wpm)) + ' ك/د بصحة ' + format_int(round_int(acc)) + '٪).'
//     // format_int(round_int(wpm)) + ' ك/د)<br>(بصحة ' + format_int(round_int(acc)) + '٪ — ' + format_plural_word(wrong_chars, ws_letters) + ')'
//     // format_plural_word(round_int(wpm), ws_words) + ' في الدقيقة]<br>(' +
//     // format_plural_word(round_int(len), ws_letters) + ' في ' +
//     // format_plural_word(round_int(sec), ws_seconds) + ')'
//     + (+lesson < LETTERS.length
//         ? ('<br>تقدم إلى ' + lesson_link(+lesson + 1) + ' أو أعد ' + lesson_link(+lesson) + '.')
//         : ('<br>لقد أنهيت جميع الدروس! يمكنك الانطلاق، أو إعادة ' + lesson_link(+lesson) + '.')
//     )
//     + (acc >= 90 ? '' :
//         '<br>ولكن بهذه الصحة القليلة، الأفضل أن تعيد ' + lesson_link(+lesson) + '.'
//     )
// )

function ligature_need_break (prev, ltr) {
    return !!(prev + ltr).match(/ل[اأإآ]|[لم]م/)
    // lam-alef ligatures, and lam-meem and meem-meem b/c Kawkab Mono uses them
}
