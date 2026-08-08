# slidingWindowMax
#
# Given an integer array nums and a window size k, return an array containing
# the maximum value of each contiguous window of size k as it slides from the
# start of the array to the end.
#
# sliding_window_max([1, 3, -1, -3, 5, 3, 6, 7], 3)
# # windows: [1,3,-1] [3,-1,-3] [-1,-3,5] [-3,5,3] [5,3,6] [3,6,7]
# # => [3, 3, 5, 5, 6, 7]
#
# Constraints to aim for: better than the naive O(n·k) — a single pass, O(n) overall.

def sliding_window_max(nums, k)
  deque = [] # indices into nums, kept so nums[deque] is decreasing front-to-back
  result = []

  nums.each_with_index do |n, i|
    deque.pop while !deque.empty? && nums[deque.last] <= n
    deque.push(i)

    deque.shift if deque.first <= i - k

    result << nums[deque.first] if i >= k - 1
  end

  result
end
