# Given an array of strings, group the ones that are anagrams of each other.
# Order of groups and order within groups doesn't matter.
#

# keep a running hash of groups
# words.each do |word|
#   check if word is anagram of first word in each group
#     if yes that group << word
#     otherwise group << new group
#
# return group

# anagram?(w1, w2)
#   w1.size != w2.size -> return false
#   sort by char w1 and w2, if equal return true
#   -> false

def group_anagrams(words)
  groups = []
  words.each do |word|
    found = false
    groups.each do |group|
      if anagram?(word, group[0])
        found = true
        group << word
        break
      end
    end
    groups << [word] unless found
  end

  return groups
end

def anagram?(w1, w2)
  return false unless w1.size == w2.size
  w1.chars.sort.join == w2.chars.sort.join
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"]),
  [["eat", "tea", "ate"], ["tan", "nat"], ["bat"]])
check(group_anagrams([]), [])
check(group_anagrams([""]), [[""]])
check(group_anagrams(["a"]), [["a"]])
