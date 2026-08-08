# You're given someone's busy intervals for the day as [start, end] pairs
# (integers, e.g. minutes since midnight), possibly unsorted and possibly
# overlapping or touching. You're also given their working hours as a
# [start, end] pair. Return the list of free [start, end] slots within
# working hours — i.e. the gaps not covered by any busy interval.
#
# free_time([[540, 600], [630, 660]], [540, 720])
#   # => [[600, 630], [660, 720]]
# free_time([[540, 660], [600, 630]], [540, 720])
#   # => [[660, 720]]   (overlapping busy intervals merge first)
# free_time([], [540, 720])
#   # => [[540, 720]]

def free_time(busy, working_hours)
  return [working_hours] if busy.empty?
  return [] if working_hours.empty?

  results = []
  current = working_hours.first
  busy
    .sort_by { |left, right| [left, -right] }
    .each do |(left, right)|
      if left > current
        results << [current, left]
      end

      current = [current, right].max
      return results if current >= working_hours.last
    end
  # ensured either correct or skipped by the last line in the previous loop.
  results << [current, working_hours.last]
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(free_time([[540, 600], [630, 660]], [540, 720]), [[600, 630], [660, 720]])
check(free_time([[540, 660], [600, 630]], [540, 720]), [[660, 720]])
check(free_time([[540, 720]], [540, 720]), [])
check(free_time([[500, 600], [650, 800]], [540, 720]), [[600, 650]])
check(free_time([], [540, 720]), [[540, 720]])
check(free_time([540, 720], []), [])
check(free_time([[400, 540], [720, 1000]], [540, 720]), [[540, 720]])

