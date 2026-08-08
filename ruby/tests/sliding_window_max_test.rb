require "minitest/autorun"
require_relative "../sliding_window_max"

class SlidingWindowMaxTest < Minitest::Test
  def test_given_example
    assert_equal [3, 3, 5, 5, 6, 7], sliding_window_max([1, 3, -1, -3, 5, 3, 6, 7], 3)
  end

  def test_window_size_one_returns_the_array_unchanged
    assert_equal [1, 3, -1, -3, 5, 3, 6, 7], sliding_window_max([1, 3, -1, -3, 5, 3, 6, 7], 1)
  end

  def test_window_size_equal_to_array_length_returns_single_max
    assert_equal [7], sliding_window_max([1, 3, -1, -3, 5, 3, 6, 7], 8)
  end

  def test_strictly_increasing_array
    assert_equal [3, 4, 5], sliding_window_max([1, 2, 3, 4, 5], 3)
  end

  def test_strictly_decreasing_array
    assert_equal [5, 4, 3], sliding_window_max([5, 4, 3, 2, 1], 3)
  end

  def test_duplicate_max_values
    assert_equal [4, 4, 4], sliding_window_max([4, 4, 1, 4], 2)
  end

  def test_stress_against_naive_reference
    reference = ->(nums, k) { nums.each_cons(k).map(&:max) }

    2000.times do
      nums = Array.new(rand(1..40)) { rand(-20..20) }
      k = rand(1..nums.size)

      assert_equal reference.call(nums, k), sliding_window_max(nums, k),
                    "mismatch for nums=#{nums.inspect} k=#{k}"
    end
  end
end
