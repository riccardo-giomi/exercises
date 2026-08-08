function excelColumnToInteger(string) {
  const oneIndexed = [...string].reduce(
    (total, char) => total * 26 + (char.charCodeAt(0) - 64),
    0
  )
  return oneIndexed - 1
}

console.log(excelColumnToInteger("A"), "// A => 0")
console.log(excelColumnToInteger("B"), "// B => 1")
console.log(excelColumnToInteger("Z"), "// Z => 25")
console.log(excelColumnToInteger("AA"), "// AA => 26")
console.log(excelColumnToInteger("AZ"), "// AZ => 51")
console.log(excelColumnToInteger("BA"), "// BA => 52")
console.log(excelColumnToInteger("BZ"), "// BZ => 77")
console.log(excelColumnToInteger("ZZ"), "// ZZ => 701")
console.log(excelColumnToInteger("AAA"), "// AAA => 702")

module.exports = excelColumnToInteger
