# Write a method that takes a string and returns the index of the first
# character that doesn't repeat anywhere else in the string. If every character
# repeats, return -1.
def first_unique_char(string)
  counts = {}
  string.each_char do |char|
    if counts[char]
      counts[char] += 1
    else
      counts[char] = 1
    end
  end

  string.each_char.with_index do |char, index|
    return index if counts[char] == 1
  end
  -1 
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status.inspect}: got=#{actual} wanted=#{expected.inspect}"
end

check(first_unique_char(""), -1)
check(first_unique_char("leetcode"), 0)
check(first_unique_char("loveleetcode"), 2)
check(first_unique_char("aabb"), -1)
check(first_unique_char("aaaaaaaaaaaab"), 12)
