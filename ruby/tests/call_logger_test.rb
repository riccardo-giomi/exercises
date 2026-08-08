require "minitest/autorun"
require_relative "../call_logger"

class CallLoggerTest < Minitest::Test
  class Target
    def greet(name, greeting: "Hello")
      "#{greeting}, #{name}!"
    end

    def sum_doubled(*nums)
      nums.map { |n| yield(n) }.sum
    end

    private

    def secret
      "shh"
    end
  end

  def setup
    @array_logger = CallLogger.new([3, 1, 2])
    @target = Target.new
    @target_logger = CallLogger.new(@target)
  end

  def test_forwards_call_and_returns_target_result
    assert_equal [1, 2, 3], @array_logger.sort
  end

  def test_counts_forwarded_calls_per_method_name
    @array_logger.sort
    @array_logger.sort
    @array_logger.first

    assert_equal 2, @array_logger.calls_to(:sort)
    assert_equal 1, @array_logger.calls_to(:first)
    assert_equal 0, @array_logger.calls_to(:never_called)
  end

  def test_forwards_positional_and_keyword_arguments
    assert_equal "Hi, Ada!", @target_logger.greet("Ada", greeting: "Hi")
  end

  def test_forwards_a_block
    result = @target_logger.sum_doubled(1, 2, 3) { |n| n * 2 }
    assert_equal 12, result
  end

  def test_respond_to_reflects_targets_public_methods
    assert @array_logger.respond_to?(:sort)
    refute @array_logger.respond_to?(:nonsense)
  end

  def test_respond_to_is_false_for_targets_private_methods
    refute @target_logger.respond_to?(:secret)
  end

  def test_does_not_forward_methods_defined_on_call_logger_itself
    @target_logger.calls_to(:greet) # a real CallLogger method, not forwarded
    assert_equal 0, @target_logger.calls_to(:calls_to)
  end

  def test_calling_a_nonexistent_method_still_counts_the_attempt
    assert_raises(NoMethodError) { @array_logger.definitely_not_a_method }
    assert_equal 1, @array_logger.calls_to(:definitely_not_a_method)
  end

  def test_calling_targets_private_method_raises
    assert_raises(NoMethodError) { @target_logger.secret }
  end
end
