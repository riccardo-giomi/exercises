# medianOfArray
#
# Given an array of numbers (unsorted, no duplicates assumption needed), return
# the median value. For odd-length arrays, that's the middle element once
# sorted; for even-length arrays, return the average of the two middle
# elements.
#
# Example:
# median([5, 2, 8, 1, 9])       # => 5
# median([5, 2, 8, 1])          # => 3.5   ((2+5)/2)


def partition(array, low = 0, high = array.size - 1)
  pivot_index = high

  pivot = array[pivot_index]
  boundary = low
  (low...high).each do |i|
    if array[i] < pivot
      array[i], array[boundary] = array[boundary], array[i]
      boundary += 1
    end
  end
  array[high], array[boundary] = array[boundary], array[high]
  boundary
end

def find_rank(array, target, low = 0, high = array.size - 1)
  rank = partition(array, low, high)

  while target != rank
    if rank < target
      low = rank + 1
    else
      high = rank - 1
    end
    rank = partition(array, low, high)
  end 
  rank
end

def median(values)
  return nil unless values.size > 0

  array = values.dup
  middle = (values.size / 2)

  first_rank = find_rank(array, middle)
  return array[first_rank] if values.size.odd?

  second_rank = find_rank(array, middle - 1, 0, first_rank - 1)

  (array[first_rank] + array[second_rank]) / 2.0
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(median([5, 2, 8, 1, 9]), 5)
check(median([5, 2, 8, 1]), 3.5)
check(median([]), nil)
check(median([1]), 1)
check(median([19, 12, -1, 5, -6, -7, 0, -14, -7]), -1)

