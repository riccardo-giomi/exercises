function runLengthEncode(string) {
  if (string.length == 0) return ""
  const results = []

  let count = 1
  let lastChar = string[0]

  let index = 1
  while (index <= string.length) {
    const char = string[index]

    if (index == string.length) {
      pushChar(lastChar)
    }
    else if (char == lastChar) {
      count++
    }
    else {
      pushChar(lastChar)
      lastChar = char
      count = 1
    }
    index++
  }

  return results.join('')

  function pushChar(char) {
    results.push(char)
    results.push(count)
  }
}

console.log(runLengthEncode(""), "// '' => '' ")
console.log(runLengthEncode("a"), "// 'a' => 'a1' ")
console.log(runLengthEncode("aa"), "// 'aa' => 'a2' ")
console.log(runLengthEncode("aA"), "// 'aA' => 'a1A1' ")
console.log(runLengthEncode("aaabbbccd"), "// 'aaabbbccd' => 'a3b3c2d1' ")
console.log(runLengthEncode("aabbbbaa"), "// 'aabbbbaa' => 'a2b4a2' ")
console.log(runLengthEncode("aAbBaaA"), "// 'aAbBaaA' => 'a1A1b1B1a2A1' ")
