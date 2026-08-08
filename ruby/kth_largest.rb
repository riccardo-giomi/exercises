# Given an unsorted array of integers and an integer k, return the kth largest
# element (not the kth distinct value — duplicates count separately).
#
# kth_largest([3, 2, 1, 5, 6, 4], 2)        # => 5
# kth_largest([3, 2, 3, 1, 2, 4, 5, 5, 6], 4) # => 4
# kth_largest([1], 1)

def partition(values, low, high)
  pivot = values[high]
  boundary = low

  (low...high).each do |i|
    if values[i] < pivot
      values[boundary], values[i] = values[i], values[boundary]
      boundary += 1
    end
  end
  values[high], values[boundary] = values[boundary], values[high]
  boundary # == pivot position after partitioning
end

def kth_largest(values, k)
  target = values.size - k
  low = 0
  high = values.size - 1

  begin
    p = partition(values, low, high)
    if(p < target)
      low = p + 1
    else
      high = p - 1
    end
  end while p != target
  values[p]
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

p "# Check partition"
check(partition([3, 2, 1, 5, 6, 4], 0, 5), 3)
check(partition([4, 8, 2, 6, 3], 0, 4), 1)

p "#kth_largest"
check(kth_largest([3, 2, 1, 5, 6, 4], 2), 5)
check(kth_largest([3, 2, 3, 1, 2, 4, 5, 5, 6], 4), 4)
check(kth_largest([1], 1), 1)
check(kth_largest([7, 7, 7], 2), 7)

