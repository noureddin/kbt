const WORDS = []  // not used; everything is FULL_WORDS

const want_full_words = (letters) => true

const WORDS_LIMIT = 100
const FULL_WORDS_LIMIT = WORDS_LIMIT  // Math.round(WORDS_LIMIT / 2)

const lessons_ordinal = ['1', '2', '3', '4', '5', '6' ].map(e => 'Lesson&ensp;'+e)

const TXT_ENTER_ALERT = "Use Space after each word; it's faster, and it's the usual choice"

const BAD_LEFT_SHIFT_ALERT = 'Use the right-side Shift with keys on the left side of the keyboard'
const BAD_RIGHT_SHIFT_ALERT = 'Use the left-side Shift with keys on the right side of the keyboard'

// Round to arbitrary precision
const R = (e,p) => p? Math.round(e * 10**p) / 10**p : Math.round(e)

const A = (n) => n.toString()
const D = (n) => +n
const S = (n, ws) => A(n) + ' ' + (
    n === 0 ? ws[1] :
    n === 1 ? ws[0] :
        ws[1]
)

const ws_letters = ['letter', 'letters']

// the first line in the finish msg; gives wpm and/or cpm, accuracy, and possibly other stats.
const finish_msg_init = (cpm, wpm, len, sec, acc, lesson) => (
    S(R(cpm), ws_letters) + ' per minute (' +
    A(R(wpm)) + ' WPM with accuracy of ' + A(R(acc)) + '%).'
)

// the second line in the finish msg, if there are more lessons.
const finish_msg_forward = (cpm, wpm, len, sec, acc, wrong_chars, lesson) => '<br>'
    + 'Step to ' + lesson_link(lesson + 1) + ' or repeat ' + lesson_link(lesson) + '.'

// the second line in the finish msg, if it's the last lesson.
const finish_msg_end = (cpm, wpm, len, sec, acc, wrong_chars, lesson) => '<br>'
    + 'You have finish all lessons! You can go now, or repeat ' + lesson_link(lesson) + '.'

// additional line in the finish msg, if the accuracy is bad.
const finish_msg_repeat = (cpm, wpm, len, sec, acc, wrong_chars, lesson) => '<br>'
    + "but with this accuracy, it's probably better to repeat " + lesson_link(lesson) + '.'


function ligature_need_break (prev, ltr) {
    return false
}
