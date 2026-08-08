function romanNumeralToInteger(string) {
  let result = 0, oldValue = 0

  for (const char of string) {
    const value = charToDigit(char)
    if (value === undefined) return undefined

    result += value
    if (oldValue > 0 && oldValue < value) {
      result -= 2 * oldValue
    }
    oldValue = value
  }
  return result

  function charToDigit(char) {
    const digits = { "I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000 }

    return digits[char]
  }
}

console.log(romanNumeralToInteger("MILLE"), "MILLE  // => undefined")
console.log(romanNumeralToInteger("III"), "III  // => 3")
console.log(romanNumeralToInteger("IV"), " IV // => 4")
console.log(romanNumeralToInteger("IX"), " IX // => 9")
console.log(romanNumeralToInteger("XC"), " IX // => 90")
console.log(romanNumeralToInteger("LVIII"), "LVIII // => 58")
console.log(romanNumeralToInteger("MCMXCIV"), "1994 // => 1994")

module.exports = romanNumeralToInteger
