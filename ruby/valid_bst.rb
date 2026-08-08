# A binary tree node has a `value`, `left`, and `right` (either can be nil).
# Given the root of a binary tree, determine whether it's a valid binary
# search tree: for every node, ALL values in its left subtree must be
# strictly less than the node's value, and ALL values in its right subtree
# must be strictly greater — not just its immediate children.
#
# An empty tree (nil root) counts as valid.

Node = Struct.new(:value, :left, :right)

def valid_bst?(root, low = -Float::INFINITY, high = Float::INFINITY)

  return true if root.nil?
  return false unless (low < root.value && root.value < high)

  valid_left = valid_bst?(root.left, low, root.value)
  valid_right = valid_bst?(root.right, root.value, high)
  valid_left && valid_right
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

p "#valid_bst?"

#        5
#       / \
#      3   8
#     / \   \
#    1   4   9
valid_tree = Node.new(5,
  Node.new(3, Node.new(1), Node.new(4)),
  Node.new(8, nil, Node.new(9)))
check(valid_bst?(valid_tree), true)

#        5
#       / \
#      3   8
#         /
#        4
sneaky_invalid_tree = Node.new(5,
  Node.new(3),
  Node.new(8, Node.new(4), nil))
check(valid_bst?(sneaky_invalid_tree), false)

check(valid_bst?(Node.new(1)), true)
check(valid_bst?(nil), true)

#      5
#     / \
#    3   5
equal_value_tree = Node.new(5, Node.new(3), Node.new(5))
check(valid_bst?(equal_value_tree), false)

#      3.5
#         \
#          4.0
#         /
#       3.6
float_tree = Node.new(3.5, nil, Node.new(4.0, Node.new(3.6), nil))
check(valid_bst?(float_tree), true)
