# You're climbing a staircase with n steps. Each move, you can climb either 1
# or 2 steps. Return how many distinct ways there are to reach the top.
#
# climb_stairs(2)  # => 2   (1+1, 2)
# climb_stairs(3)  # => 3   (1+1+1, 1+2, 2+1)
# climb_stairs(5)  # => 8
# climb_stairs(0)  # => 1   (one way: take no steps)
#
# Constraints/variables:
#  - invariant input, integer
#  - output: integer
#  - edge cases: no stairs (input 0)
#
# Pattern: DP. similar to Fibonacci, REMEMBER memoization.
#

def climb_stairs(steps, memory = {})
  #  -> 1 if steps in [0,1]
  #  one_step = memory(steps - 1) || climb_stairs(steps - 1)
  #  two_steps = memory(steps - 2) || climb_stairs(steps - 2)
  #  -> one_step + -> two_steps
  return 1 if [0, 1].include?(steps)
  memory[steps - 1] = climb_stairs(steps - 1, memory) if memory[steps - 1].nil?
  memory[steps - 2] = climb_stairs(steps - 2, memory) if memory[steps - 2].nil?

  memory[steps - 2] + memory[steps - 1]
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(climb_stairs(2), 2)
check(climb_stairs(3), 3)
check(climb_stairs(5), 8)
check(climb_stairs(0), 1)
