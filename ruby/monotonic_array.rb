# Monotonic array
#
# Given an array of integers, determine whether it's monotonic — meaning it's
# either entirely non-decreasing or entirely non-increasing (ties allowed either
# way).
#
# monotonic?([1, 2, 2, 3])   # => true   (non-decreasing)
# monotonic?([6, 5, 4, 4])   # => true   (non-increasing)
# monotonic?([1, 3, 2])      # => false
# monotonic?([5])            # => true


def monotonic?(values)
  return true if values.size < 2
  increasing = values.first <= values.last
  compare = if increasing
    proc { |a, b| a <= b }
  else
    proc { |a, b| a >= b }
  end
  values.each_cons(2).all?(&compare)
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(monotonic?([]), true)
check(monotonic?([2, 2, 2, 2]), true)
check(monotonic?([1, 2, 2, 3]), true)
check(monotonic?([6, 5, 4, 4]), true)
check(monotonic?([1, 3, 2]), false)
check(monotonic?([5]), true)
