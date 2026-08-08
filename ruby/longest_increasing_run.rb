# Given an array of integers, return the longest contiguous run of strictly
# increasing values (as a sub-array). If there's a tie, return the first one
# found.


# Nature:
# Input:
#   array order is fixed, integers. Read-only
# Output:
#   is a sub-array of integers, those  contiguous and
#   strictly incresing values from input.
#   Single value array valid.
#   Tie -> first found wins
# Edge cases: empty array, input with all values equal, all decresing input.
def longest_increasing_run(array)
  # longest = [1 5] | [3 6 7]
  # 1 5 3 6 7
  #     ^
  #         ^
  # return [] if array.empty?
  # longest found starts as first integer || empty
  # with left and right indexes starting at first integer
  #  return longest if right cannot move right
  #  if i[right] > i[right - 1]
  #    if right - left > longest.size - 1
  #      longest = array[left..right]
  #  else
  #    left = right
  #  end
  #  return longest

  return [] if array.empty?
  left = 0
  right = 1
  longest = [array[0]]

  while right < array.size
    if array[right] > array[right - 1]
      longest = array[left..right] if right - left > longest.size - 1
    else
      left = right
    end
    right += 1
  end  

  return longest
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(longest_increasing_run([1, 2, 3, 2, 3, 4, 5, 0]), [2, 3, 4, 5])
check(longest_increasing_run([5, 4, 3, 2, 1]), [5])
check(longest_increasing_run([3, 3, 3, 3, 3]), [3])
check(longest_increasing_run([]), [])
check(longest_increasing_run([1, 5, 3, 6, 7]), [3, 6, 7])
