# Given the head of a singly linked list, determine whether it contains a cycle
# (some node's next eventually points back to an earlier node in the list,
# rather than to nil).
#
# 1 -> 2 -> 3 -> 4 -> 5 -> 2  (points back to node 2)   => true
# 1 -> 2 -> 3 -> nil                                     => false
#

class Node
  def initialize(value, nxt=nil)
    @value = value
    @next = nxt
  end

  attr_accessor :value
  attr_reader :next

  def next=(node)
    @next = node
  end

  def inspect
    return @value.inspect unless @next
    "#{@value.inspect} -> #{@next.inspect}"
  end
end

def from_labels(labels)
  root = prev = nil
  seen = {}

  labels.each do |label|
    if seen[label]
      prev.next = seen[label]
      return root
    end

    node = seen[label] = Node.new(label)
    prev.next = node if prev
    root ||= node
    prev = node
  end

  return root
end

def from_pos(values, pos)
  return nil if values.empty?

  root = prev = nil
  pos_node = nil

  0.upto(values.size - 1) do |i|
    node = Node.new(values[i])
    pos_node = node if i == pos # works even if pos = nil
    prev.next = node if prev
    root ||= node
    prev = node
  end

  prev.next = pos_node if pos

  root
end

def has_cycle(node)
  slow = node
  fast = node&.next&.next

  while fast
    fast = fast&.next&.next
    slow = slow.next
    return true if fast == slow
  end

  return false
end


def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(has_cycle(from_labels([])), false)
check(has_cycle(from_labels([1])), false)
check(has_cycle(from_labels([1, 1])), true)
check(has_cycle(from_labels([1, 2, 1])), true)
check(has_cycle(from_labels([1, 2, 3, 4, 5, 2])), true)
check(has_cycle(from_labels([1, 2, 3])), false)

check(has_cycle(from_pos([], nil)), false)
check(has_cycle(from_pos([1], nil)), false)
check(has_cycle(from_pos([1], 0)), true)
check(has_cycle(from_pos([1, 2], 0)), true)
check(has_cycle(from_pos([1, 2, 3, 4, 5], 1)), true)
check(has_cycle(from_pos([1, 2, 3], nil)), false)
