# Given an array of values, return the array's mode(s): the value(s) that
# occur most frequently. There can be more than one (a tie for most frequent).
# Return them sorted ascending. An empty input has no modes.
#
# modes([1, 1, 2, 2, 3])       # => [1, 2]
# modes([4, 4, 4, 5])          # => [4]
# modes([7, 8, 9])             # => [7, 8, 9]
# modes([])                    # => []

def modes(values)
  return [] if values.empty?

  tally = values.tally
  max = tally.values.max
  tally.select { |_, v| v == max }.keys.sort
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

p "#modes"
check(modes([1, 1, 2, 2, 3]), [1, 2])
check(modes([4, 4, 4, 5]), [4])
check(modes([7, 8, 9]), [7, 8, 9])
check(modes([]), [])
check(modes([5]), [5])
check(modes([2, 2, 2, 1, 1, 1, 3]), [1, 2])
