# Given an array of numbers and a percentile p (an integer from 1 to 100),
# return the value at that percentile using the "nearest-rank" definition:
# sort the values ascending, then take the element at rank
# ceil(p / 100.0 * n), counting ranks from 1.
#
# percentile_value([15, 20, 35, 40, 50], 40)  # => 20
# percentile_value([15, 20, 35, 40, 50], 50)  # => 35
# percentile_value([15, 20, 35, 40, 50], 100) # => 50
# percentile_value([7], 37)                   # => 7

def percentile_value(values, p)
  return nil if values.empty? || p <= 0 || p > 100

  n = values.size
  rank = ((p / 100.00) * n).ceil

  ranked_values = values.sort
  ranked_values[rank - 1]
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

p "#percentile_value"
check(percentile_value([15, 20, 35, 40, 50], 40), 20)
check(percentile_value([15, 20, 35, 40, 50], 50), 35)
check(percentile_value([15, 20, 35, 40, 50], 100), 50)
check(percentile_value([15, 20, 35, 40, 50], 1), 15)
check(percentile_value([7], 37), 7)
check(percentile_value([5, 1, 9, 3], 75), 5)
