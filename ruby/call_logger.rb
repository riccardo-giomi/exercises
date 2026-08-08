# CallLogger

class CallLogger
  def initialize(target)
    @target = target
    @calls = Hash.new(0)
  end

  def calls_to(method_name)
    @calls[method_name]
  end

  def method_missing(name, ...)
    @calls[name] += 1
    @target.public_send(name, ...)
  end

  def respond_to_missing?(...)
    @target.respond_to?(...)
  end
end

# Requirements:
# - CallLogger.new(some_object) wraps some_object. Any method call not
#   explicitly defined on CallLogger should be forwarded to @target, with the
#   same arguments and block, and return whatever @target's method returns.
# - Each forwarded call increments a counter for that method name, retrievable
#   via calls_to(:method_name).
# - respond_to?(:whatever) on the logger must correctly reflect whether @target
#   responds to it — not just "true for everything" or "false for everything you
#   didn't explicitly define."
# - Don't forward calls_to itself, or anything actually defined on
#   CallLogger/Object — only genuinely-missing methods.

# Example:
# logger = CallLogger.new([3, 1, 2])
# logger.sort            # => [1, 2, 3]  (forwarded to the array)
# logger.calls_to(:sort) # => 1
# logger.respond_to?(:sort)     # => true
# logger.respond_to?(:nonsense) # => false

