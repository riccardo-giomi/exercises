# Given an array of integers where one value appears more than n/2 times (n =
# array length), return that value. You're guaranteed exactly one such value
# exists.
#
# majority_element([3, 2, 3])           # => 3
# majority_element([2, 2, 1, 1, 1, 2, 2]) # => 2
# majority_element([1])                 # => 1


# Unsorted input, inmutable
# Return value is a positive integer,
# a single result is always guaranteed.
# No problem with ties.
# Edge cases: all values the same, only one value.
#
# Pattern: count with hash memory, stop when saving a value > n/2

def majority_element(values)
  # Prepare a Hash to store counts per value
  # for each value
  # count = (Hash[value] or 0) + 1
  # -> count if count > values.size / 2
  # Hash[value] = count

  goal = values.size / 2
  counts = {}

  values.each do |value|
    count = counts[value] || 0
    count += 1
    return value if count > goal
    counts[value] = count
  end
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(majority_element([9, 9, 9]), 9)
check(majority_element([3, 2, 3]) , 3)
check(majority_element([2, 2, 1, 1, 1, 2, 2]) , 2)
check(majority_element([1]) , 1)
check(majority_element([5, 5, 1, 1, 1, 1, 1]), 1)
