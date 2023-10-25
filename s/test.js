function test_S() {
    let tests = 0
    let correct = 0
    ;[
        [0, '٠ حرف'],
        [1, '١ حرف'],
        [2, '٢ حرفين'],
        [3, '٣ أحرف'],
        [9, '٩ أحرف'],
        [10, '١٠ أحرف'],
        [11, '١١ حرفًا'],
        [90, '٩٠ حرفًا'],
        [99, '٩٩ حرفًا'],
        [111, '١١١ حرفًا'],
        [100, '١٠٠ حرف'],
        [299, '٢٩٩ حرفًا'],
        [1000, '١٠٠٠ حرف'],
        [1100, '١١٠٠ حرف'],
    ].forEach(x => {
        ++tests
        const [n, exp] = x
        const got = S(n, ws_letters)
        if (got !== exp) { say(got, '≠', exp, '→', n) }
        else { ++correct }
    })
    say('S() tests successed', correct, 'out of', tests, 'total. Failed', tests - correct)
}
test_S()

