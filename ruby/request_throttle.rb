# requestThrottle
#
# You're implementing a simple rate limiter for an API client. Given a list of
# request timestamps (integers, in seconds, strictly increasing — already in
# order) and two parameters window (seconds) and limit (max requests allowed in
# any window-second span), return the list of timestamps that would have been
# rejected — i.e. any request that, at the time it fired, would put the count of
# requests within the trailing window seconds (including itself) over limit.
# Rejected requests don't count toward future windows.
#
# throttled([1, 2, 3, 4, 10, 11], window: 5, limit: 3)
# # request at t=1: window[-4..1]=[1] -> 1 <= 3, allowed
# # request at t=2: [1,2] -> allowed
# # request at t=3: [1,2,3] -> allowed (at limit)
# # request at t=4: [1,2,3,4] within last 5s -> would be 4th, rejected
# # request at t=10: nothing in [5..10] except itself -> allowed
# # request at t=11: [10,11] -> allowed
# # => [4]

def throttled(values, window:, limit:)
  queue = []
  rejects = []

  values.each do |value|
    # Sliding window:
    # (value - window, value]
    left = value - window + 1

    # Check the queue for past requests now out of the window
    queue.shift while queue.first && (queue.first < left)
    if(queue.size) == limit
      rejects << value
    else
      queue << value
    end
  end

  return rejects
end


def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(throttled([], window: 5, limit: 3), [])
check(throttled([1, 2, 3, 4, 10, 11], window: 5, limit: 3), [4])
check(throttled([1, 2, 3, 4], window: 2, limit: 1), [2,4])

