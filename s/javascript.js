'use strict'

const say = console.log

// Fisher-Yates (aka Knuth) Shuffle
// https://stackoverflow.com/a/2450976
function shuffle (arr) {
  let curIdx = arr.length
  let randIdx
  // While there remain elements to shuffle...
  while (curIdx != 0) {
    // Pick a remaining element...
    randIdx = Math.floor(Math.random() * curIdx)
    curIdx--
    // And swap it with the current element.
    [arr[curIdx], arr[randIdx]] = [arr[randIdx], arr[curIdx]]
  }
  return arr
}

const grep_contain_only = (arr, letters, old_letters='') =>
  arr.filter(e => e.match(RegExp(`^[${letters.replace(/-/g, '\\-')}]+$`)))
  .filter(e => !e.match(RegExp(`^[${old_letters.replace(/-/g, '\\-')}]+$`)))

const letters_for_lesson = (n) => LETTERS[+n - 1]

const limit_for_lesson = (n) => want_full_words(LETTERS[+n - 1]) ? FULL_WORDS_LIMIT : WORDS_LIMIT

const words_for_lesson = (n, lim) => {
  n = +n - 1
  const letters = LETTERS[n]
  const [words, words_limit] = want_full_words(letters) ? [ FULL_WORDS, FULL_WORDS_LIMIT ] : [ WORDS, WORDS_LIMIT ]
  const limit = lim ? lim : words_limit
  const old_letters = LETTERS.slice(0, n).reduce((cur, cum) => cur + cum, '')
  const result = grep_contain_only(words, letters, old_letters)
  // say('=>', limit, result.length)
  return shuffle(
    result.length >= limit
      ? shuffle(result).slice(0, limit)
      : [...result, ...shuffle(grep_contain_only(words, letters)).slice(0, limit - result.length)]
    )
  // the inner shuffles are to pick random slice of words
}

const now = () => (new Date()).getTime()

const Q = (q) => document.querySelector(q)
const Qid = (q) => document.getElementById(q)
const Qall = (q) => document.querySelectorAll(q)

const eradicate_class = (cls) =>
  Qall('.'+cls).forEach(e => e.classList.remove(cls))

// TODO: replace innerText setter with textContent

const explode_word = (el_word) => {
  el_word.innerHTML = el_word.innerText.split('').map(c => `<span>${c}</span>`).join('')
  el_word.childNodes.forEach((e, i) => {
    if (i > 0) {
      if (ligature_need_break(el_word.childNodes[i - 1].textContent, e.textContent)) {
        mark(e, 'bb')
      }
    }
  })
}

const   mark = (el, cls) => el.classList.add(cls)
const unmark = (el, cls) => el.classList.remove(cls)
const set_current = (e) => { mark(e, 'current-word'); explode_word(e); e.scrollIntoView(); el_current = e }

const correct_char = (c) => { unmark(c, 'wrong-letter');   mark(c, 'correct-letter') }
const   wrong_char = (c) => {   mark(c, 'wrong-letter'); unmark(c, 'correct-letter') }

// // BEGIN DEBUG
// LETTERS.forEach((ltrs, i) => say('Lesson', i+1, 'for', ltrs, 'has', grep_contain_only(want_full_words(ltrs) ? FULL_WORDS : WORDS, ltrs).length, 'words'))
// LETTERS.forEach((ltrs, i) => say('Lesson', i+1, 'for', ltrs, 'actually has', words_for_lesson(i+1, Infinity).length, 'words'))
// LETTERS.reduce((cur, cum, i) => {
//     cum += cur
//     cum = [...new Set(cum.split(''))].sort().join('') // uniq; https://stackoverflow.com/a/14438954
//     const words = want_full_words(cum) ? FULL_WORDS : WORDS
//     say('Cumulative', i+1, 'for', cum, 'has', grep_contain_only(words, cum).length, 'words')
//     return cum
// }, '')
// // END DEBUG

const el_compeleted = document.getElementById('completed')
const el_allwords = document.getElementById('allwords')
const el_lesson = document.getElementById('lesson')
const el_screen = document.getElementById('screen')
const el_write = document.getElementById('write')
const el_body = document.body
let el_current

function set_words(lesson) {
  el_screen.innerHTML =
    words_for_lesson(lesson)
    .map(e => `<span style="display: inline-block; width: ${0.75*e.length}em">${e}</span>`)
    .join(' ')
  const limit = limit_for_lesson(lesson)
  set_completed(0, limit)
  el_allwords.innerText = A(limit)
}

let kb = {}
const _key = (x) =>
  x === 'BS' ? '\b' :
  x === 'SPACE' ? ' ' :
  x.startsWith('&nbsp;') ? x.split(';').pop() :  // vowel marks
    x[0]
// first char only to disregard <sup>s and any presentational ZWJ
Qall('#keyboard > span > *').forEach(e => { kb[_key(e.innerHTML)] = e })
// Qall('#keyboard > span > *').forEach(e => { say(e.innerHTML) })
// say(kb)

// // equiv to want.startsWith(got), but allows swapping two consecutive vowel marks
// // (a Shadda and any other vowels except sukun)
// function right_so_far() {
//     const want = el_current.innerText
//     const got = el_write.value
//     if (want.startsWith(got)) { return true }
//     if (!want.includes(Shadda)) { return false }
//     // the words with most Shaddas has three
//     let count = want.replace(/[^ّ]+/g, '').length
//     // Shadda always comes before another vowel in our list
//     if (count === 1) {
//         const new1 = want.replace(/(ّ)(.)/, '$2$1')
//         if (new1.substr.startsWith(got)) { return true }
//     }
//     else if (count === 2) {
//         const new1 = want.replace(/(ّ)(.)/, '$2$1')
//         const new2 = want.replace(/(ّ.+?)(ّ)(.)/, '$1$3$2')
//         if (new1.substr.startsWith(got)) { return true }
//         if (new2.substr.startsWith(got)) { return true }
//     }
//     else if (count === 3) {
//         const new1 = want.replace(/(ّ)(.)/, '$2$1')
//         const new2 = want.replace(/(ّ.+?)(ّ)(.)/, '$1$3$2')
//         const new3 = want.replace(/(ّ.+?ّ.+?)(ّ)(.)/, '$1$3$2')
//         if (new1.substr.startsWith(got)) { return true }
//         if (new2.substr.startsWith(got)) { return true }
//         if (new3.substr.startsWith(got)) { return true }
//     }
//     return false
// }

function get_next_key() {
  if (!el_current) { return }
  const want = el_current.innerText
  const got = el_write.value
  return (
    want === got ? ' ' :
    want.startsWith(got) ? want[got.length] :
    // right_so_far() ? want[got.length] :
    '\b'  // backspace
  )
}

const highlighter = (function () {
  let id
  return {
    end: function () { clearInterval(id) },
    start: function () {
      clearInterval(id)
      eradicate_class('hihi')
      const ch = get_next_key()
      const e = kb[ch]
      if (e) {
        const hili = () => e.classList.add('hihi')
        ch === '\b' ? hili() : id = setInterval(hili, 5000)  // 5 sec
      }
    },
  }
})()

function set_completed(n, limit) {
  limit ||= D(el_allwords.innerText)
  limit -= 1  // because we'll never show 100/100 words; instead it's replaced by "Done" 
  const len = limit.toString().length
  el_compeleted.innerText = A(n.toString().padStart(len, '0'))
}

function next_word (cur) {
  const next = cur.nextSibling?.nextSibling  // the direct next is a space
  if (next) {
    const n = D(el_compeleted.innerText) + 1
    set_completed(n)
    set_current(next)
    return true
  }
}

const lesson_link = (n) =>
  '<a href="?' + n + '">' + lessons_ordinal[+n - 1] + '</a>'

function finish_msg(sec, len, wrong_chars, lesson) {
  const cpm = len * 60 / sec
  const wpm = cpm / 5
  const acc = 100 - 100 * wrong_chars / len
  const args = [cpm, wpm, len, sec, acc, wrong_chars, +lesson]
  say('Lesson', lesson + ':', R(cpm,1), 'cpm;', R(wpm,1), 'wpm;', R(acc,2) + '% acc in', R(sec), 'sec —', wrong_chars, 'wrong out of', len, 'chars')
  return (
    finish_msg_init(...args)
    + (+lesson < LETTERS.length? finish_msg_forward(...args) : finish_msg_end(...args) )
    + (acc >= 90 ? '' : finish_msg_repeat(...args) )
  )
}

function play (lesson) {
  if (!lesson || lesson < 1) { lesson = 1 }
  if (lesson >= LETTERS.length) { lesson = LETTERS.length }
  window.location.hash = lesson
  window.location.search = ''
  el_lesson.value = lesson
  set_words(lesson)
  unmark(el_body, 'finish')
  eradicate_class('hi')
  letters_for_lesson(lesson).split('').forEach(c => kb[c].classList.add('hi'))
  set_current(Q('#screen > :first-child'))
  el_write.value = ''
  el_write.focus()
  highlighter.start()

  let start
  let wrong_chars = 0

  function show_finish() {
    const end = now()
    const sec = (end - start) / 1000
    const len = el_screen.innerText.length
    mark(el_body, 'finish')
    el_screen.innerHTML = finish_msg(sec, len, wrong_chars, lesson)
    start = undefined
    highlighter.end()
    el_write.oninput = () => {}
  }

  function check_input (word_finished) {
    if (start == null) { start = now() }
    const right = el_current.textContent
    const input = el_write.value.trim()
    el_write.value = input  // to remove any excess spaces in the input field itself
    for (let i = 0; i < right.length; ++i) {
      const c = el_current.childNodes[i]
      if (input[i] == null) {  // input shorter than the right word
        unmark(c, 'wrong-letter')
        unmark(c, 'correct-letter')
        // TODO: after current can be wrong too?
      }
      else {
        right[i] !== input[i] ? wrong_char(c) : correct_char(c)
      }
      // : vowels.includes(input[i]) && c.innerText === Shadda
    }
    input.length > right.length || Qall('.wrong-letter').length || get_next_key() === '\b'
      ? mark(el_current, 'wrong-word') : unmark(el_current, 'wrong-word')
    if (word_finished) {
      const correct = right === input
      el_current.innerHTML = el_current.textContent
      if (correct) {
        mark(el_current, 'correct-word')
        unmark(el_current, 'wrong-word')
        unmark(el_current, 'current-word')
        next_word(el_current) || show_finish()
      }
      else if (input) {  // only if there is a value, not empty; e.g. by pressing space
        mark(el_current, 'wrong-word')
        explode_word(el_current)
        wrong_chars += 1
      }
      else {  // if empty; ie pressed space before typing anything
        explode_word(el_current)
      }
      el_write.value = ''
    }
    else {
      wrong_chars += get_next_key() === '\b'
    }
    if (start) { highlighter.start() }
  }

  el_write.oninput = (ev) => check_input(ev.data === ' ')
}

function insert_in_field (el, ch) {
  if (!ch) { return }
  // https://stackoverflow.com/a/11077016 and comments, with modifications
  const st = el.selectionStart
  const en = el.selectionEnd
  //
  const before = el.value.substring(0, st)
  const after  = el.value.substring(en, el.value.length)
  //
  el.value = before + ch + after
  // restore cursor position
  el.selectionStart = el.selectionEnd = st + ch.length
}

const left_side = {
  Backquote: true,
    KeyQ: true,  KeyW: true,  KeyE: true,  KeyR: true,  KeyT: true,
     KeyA: true,  KeyS: true,  KeyD: true,  KeyF: true,  KeyG: true,
      KeyZ: true,  KeyX: true,  KeyC: true,  KeyV: true,  KeyB: true,
}

let prev_shift

el_write.addEventListener('keydown', (ev) => {
  const emulate = Qid('emu').checked
  if (ev.key === 'Shift') {
    prev_shift = ev.code.substr(5, 1)  // 'L' or 'R'
  }
  else if (ev.key === 'Enter') {
    alert(TXT_ENTER_ALERT)
  }
  else if (emulate && !ev.ctrlKey && !ev.altKey) {
    const k = mapping[ev.code]
    if (k) {
      ev.preventDefault()
      if (ev.shiftKey) {
        const onleft = left_side[ev.code]
        if (onleft && prev_shift === 'L') {
          alert(BAD_LEFT_SHIFT_ALERT)
        }
        else if (!onleft && prev_shift === 'R') {
          alert(BAD_RIGHT_SHIFT_ALERT)
        }
        else {
          insert_in_field(el_write, k[1])
        }
      }
      else {
        insert_in_field(el_write, k[0])
      }
      el_write.oninput(ev)
    }
  }
})

window.addEventListener('resize', () => {
  if (el_current) { el_current.scrollIntoView() }
})

window.addEventListener('load', () => {
  el_write.value = ''
  play(+window.location.hash.slice(1) || +window.location.search.slice(1) || 1)
})

// Search parameter `https://.../?4` is more convenient, e.g., to force reload the page.
// Hash parameter `https://.../#4` is the primarily supported. And if both exist, hash takes
// precedence. Always on play(), the hash is updated, and the search is removed if found.
