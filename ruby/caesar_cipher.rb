class CaesarCipher
  def initialize(shift)
    @shift = shift
  end

  def encode(string)
  string.chars.map { |char| encode_char(char) }.join
  end

  def encode_char(char)
    if char.between?("A", "Z") # A-Z
      shift(char, "A".ord)
    elsif char.between?("a", "z") # a-z
      shift(char, "a".ord)
    else char
    end
  end

  def shift(char, left)
    (left + (char.ord + @shift - left) % 26).chr
  end
end

# "", 3 -> ""
p CaesarCipher.new(3).encode("")
# "Hello", 0 -> "Hello"
p CaesarCipher.new(0).encode("Hello")
# "Hello, World!", 3 -> "Khoor, Zruog!"
p CaesarCipher.new(3).encode("Hello, World!")
# "Khoor, Zruog!" -> "Hello, World!"
p CaesarCipher.new(-3).encode("Khoor, Zruog!")
# "ABC, abc", 3 -> "DEF def"
p CaesarCipher.new(3).encode("ABC, abc")
# "XYZ", 29 -> "ABC"
p CaesarCipher.new(29).encode("XYZ")
# "XYZ, xyz", 5 -> "CDE cde
p CaesarCipher.new(5).encode("XYZ, xyz")
# "AzY23", 4 -> "EdC23"
p CaesarCipher.new(4).encode("AzY23")
