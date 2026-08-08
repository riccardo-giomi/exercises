# daily_temperatures
#
# Given an array of daily temperatures, return an array answer where answer[i] is
# the number of days you'd have to wait after day i to get a warmer temperature.
# If there is no future day for which this is possible, put 0 instead.
#
# Input:  [73, 74, 75, 71, 69, 72, 76, 73]
# Output: [1, 1, 4, 2, 1, 1, 0, 0]
#
# Pattern: monotonic stack
# We will bring past unanswered questions, in the form of indeces, in the
# present using the stack.
# Every index in the stack represents a termperature that has not yet found a
# higher temperature in the following days we have explored so far.
# When we get to a new day, we check the current temperature with previous days by:
# - peeking at the stack;
# - if the element's temp is lower, popping it and setting the corresponding
#   value in the answer to the distance between the stack element and the
#   current element;
# - we do this until the stack is empty or we peek at an element with higher temperature;
# - we push the current element in the stack


def daily_temperatures(temperatures)
  n = temperatures.size
  results = [0] * n
  stack = []

  (0...n).each do |i|
    temperature = temperatures[i]

    while(!stack.empty? && temperatures[stack.last] < temperature)
      j = stack.pop
      results[j] = i - j
    end

    stack.push(i)
  end

  results
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(daily_temperatures([73, 74, 75, 71, 69, 72, 76, 73]), [1, 1, 4, 2, 1, 1, 0, 0])
check(daily_temperatures([30, 29, 29, 21, 20, 20, 19]), [0, 0, 0, 0, 0, 0, 0])
check(daily_temperatures([70, 70, 70]), [0, 0, 0])
check(daily_temperatures([73, 73, 74]), [2, 1, 0])
check(daily_temperatures([1, 2, 3, 4]), [1, 1, 1, 0])
check(daily_temperatures([50]), [0])
check(daily_temperatures([]), [])
