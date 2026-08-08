# wordFrequencyRank
#
# Given a string of text, return the k most frequent words, ordered by:
# 1. frequency descending
# 2. on a tie, alphabetically ascending
#
# words are separated by whitespace, case-insensitive ("The" and "the" count
# together), punctuation should be stripped. Return an array of the top k words
# as lowercase strings, sorted per the tie-break rule above.
#
# Example: word_frequency_rank("the day is sunny the the the sunny is is", 2) #
# counts: the=4, is=3, sunny=2, day=1 # => ["the", "is"]


def word_frequency_rank(string, rank)
  words = string.gsub(/[^\w\-\s]/, '').downcase.split
  ranked = words.tally.sort_by { |k, v| [-v, k] }

  ranked[0...rank].map(&:first)
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(word_frequency_rank("", 2), [])
check(word_frequency_rank("word1\tword2", 2), ["word1", "word2"])
check(word_frequency_rank("dashes-work", 2), ["dashes-work"])
check(word_frequency_rank("some     spaces  were had \t and some \t tabs were added", 2), ["some", "were"])
check(word_frequency_rank("the day is sunny the the the sunny is is", 2), ["the", "is"])
