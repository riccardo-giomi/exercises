# doubleBooked
#
# You're building a calendar conflict-checker. Given a list of meetings, each
# as [start, end) in minutes since midnight, determine whether any two meetings
# overlap. If so, return the pairs of indices that conflict (empty array if no
# conflicts).
#
# double_booked([[0, 30], [30, 60], [45, 90]])
# # meeting 0 [0,30) and meeting 1 [30,60) touch but don't overlap (end is exclusive)
# # meeting 1 [30,60) and meeting 2 [45,90) do overlap
# # => [[1, 2]]
#
# double_booked([[0, 10], [20, 30]])
# # => []

def double_booked(meetings)
  sorted = meetings.each_with_index.sort_by { |(low, _), _| low }

  active = []
  doubles = []

  sorted.each do |(low, high), i|
    active.reject! { |meeting| meeting[:end] <= low }
    active.each { |meeting| doubles << [meeting[:i], i].sort }
    active << { i:, end: high }
  end

  doubles
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(double_booked([]), [])
check(double_booked([[0, 10], [20, 30]]), [])
check(double_booked([[20, 30], [0, 10]]), [])
check(double_booked([[0, 30], [30, 60], [45, 90]]) , [[1, 2]])
check(double_booked([[45, 90], [10, 60], [0, 90]]).sort , [[0, 1], [0, 2], [1, 2]].sort)
check(double_booked([[0, 10], [20, 30]]) , [])
check(double_booked([[100, 110], [0, 50], [10, 20]]), [[1, 2]])
