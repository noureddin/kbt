const strip = (w) => w.replace(/[ًٌٍَُِّْ]/g,'')  // remove vowel marks

const WORDS = FULL_WORDS
    .map(strip)
    .filter((e, i, a) => e !== a[i-1])  // uniq

const want_full_words = (letters) => letters.match(/[ًٌٍَُِّْ]/)

const WORDS_LIMIT = 100
const FULL_WORDS_LIMIT = Math.round(WORDS_LIMIT / 2)

const lessons_ordinal = ['أول', 'ثاني', 'ثالث', 'رابع', 'خامس', 'سادس', 'سابع', 'ثامن', 'أخير'].map(e => 'الدرس&ensp;ال'+e)

const TXT_ENTER_ALERT = 'اضغط زر المسافة بعد كل كلمة، فهو أسرع، وهو المعتاد'

const BAD_LEFT_SHIFT_ALERT = 'استخدم زر العالي الأيمن مع الأزرار التي على يسار اللوحة'
const BAD_RIGHT_SHIFT_ALERT = 'استخدم زر العالي الأيسر مع الأزرار التي على يمين اللوحة'

// // Round to arbitrary precision
// const round_int = (e,p) => p? Math.round(e * 10**p) / 10**p : Math.round(e)
const round_int = (e) => Math.round(e)

const format_int = (n) => [...n.toString()]
    .map(c => /* c < '0' || c > '9' ? c : */ String.fromCharCode(c.charCodeAt(0) + 0x630)).join('')
const parse_int = (n) => +[...n]
    .map(c => /* c < '٠' || c > '٩' ? c : */ String.fromCharCode(c.charCodeAt(0) - 0x630)).join('')
// both are only used with numbers, so the check is removed to reduce space

const format_plural_for_letters = (n) => format_int(n) + ' ' + (
    n === 2 ? 'حرفين' :
    n % 100 > 2 && n % 100 < 11 ? 'أحرف' :
        'حرف'
)
// was using a more proper way, but was long and not used

// the first line in the finish msg; gives wpm and/or cpm, accuracy, and possibly other stats.
const finish_msg_init = (cpm, wpm, len, sec, acc, lesson) =>
    format_plural_for_letters(round_int(cpm)) + ' في الدقيقة (' +
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
