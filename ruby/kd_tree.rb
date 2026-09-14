# Non-balanced k-d tree
#
# Internal structure:
# [ [x0, y0], # root
#   [[x1, y1], nil, nil] # left subtree, leaf
#   [[x2, y2], # right subtree
#     [x3, y3],
#     [[x4, y4], nil, nil], # left leaf
#     [[x5, y5], nil nil], # right leaf
#   ]
# ]
class KdTree
  def initialize(values = [])
    @tree = nil
    values.each { |value| add(value) }
  end

  def inspect
    "#<KdTree k=2 " + (@tree.nil? ? "<Empty>" : @tree.inspect) + ">"
  end

  def empty?
    @tree.nil?
  end

  def add(value)
    if empty?
      @tree = [value, nil, nil]
    else
      find_parent_and_add(value)
    end
    @tree
  end

  def between(subtree = @tree, depth = 0, x1:, y1:, x2:, y2:)
    return [] if subtree.nil?

    results = []
    axis = axis(depth)

    (x, y), left, right = subtree

    if x.between?(x1, x2) && y.between?(y1, y2)
      results << [x, y]
    end
    if check_left?(axis, x:, y:, x1:, y1:)
      results.concat(between(left, depth + 1, x1:, y1:, x2:, y2:))
    end
    if check_right?(axis, x: , y:, x2:, y2:)
      results.concat(between(right, depth + 1, x1:, y1:, x2:, y2:))
    end

    results
  end

  private

  def check_left?(axis, x:, y:, x1:, y1:)
    (axis == 0 && x > x1) || (axis == 1 && y > y1)
  end

  def check_right?(axis, x:, y:, x2:, y2:)
    (axis == 0 && x <= x2) || (axis == 1 && y <= y2)
  end

  def find_parent_and_add(value, subtree = @tree, depth = 0)
    axis = axis(depth)

    axis_value = value[axis]
    node = subtree.first
    node_value = node[axis]

    if axis_value < node_value
      subtree[1] = subtree[1].nil? ? [value, nil, nil] : find_parent_and_add(value, subtree[1], depth + 1)
    else
      subtree[2] = subtree[2].nil? ? [value, nil, nil] : find_parent_and_add(value, subtree[2], depth + 1)
    end

    subtree
  end

  def axis(depth)
    depth % 2
  end
end

require "minitest/autorun"

class KdTreeTest < Minitest::Test
  POINTS = [[5, 4], [2, 3], [8, 1], [9, 6], [4, 7], [7, 2]].freeze

  def setup
    @tree = KdTree.new(POINTS)
  end

  def test_query_covering_everything_returns_all_points
    result = @tree.between(x1:0, y1: 0, x2: 100, y2: 100)
    assert_equal POINTS.sort, result.sort
  end

  def test_query_covering_nothing_returns_empty
    assert_equal [], @tree.between(x1: 50, y1: 50, x2: 60, y2: 60)
  end

  def test_query_subset
    # only A(5,4) and B(2,3) fall in x:0..6, y:0..5
    result = @tree.between(x1: 0, y1: 0, x2: 6, y2: 5)
    assert_equal [[2, 3], [5, 4]], result.sort
  end

  def test_query_single_point_exact_match
    result = @tree.between(x1: 9, y1: 6, x2: 9, y2: 6)
    assert_equal [[9, 6]], result
  end

  def test_single_node_tree
    tree = KdTree.new([[1, 1]])
    assert_equal [[1, 1]], tree.between(x1: 0, y1: 0, x2: 2, y2: 2)
    assert_equal [], tree.between(x1: 5, y1: 5, x2: 6, y2: 6)
  end

  def test_stress_against_naive_scan
    200.times do
      points = Array.new(rand(1..40)) { [rand(-50..50), rand(-50..50)] }
      tree = KdTree.new(points)

      x1, x2 = [rand(-50..50), rand(-50..50)].sort
      y1, y2 = [rand(-50..50), rand(-50..50)].sort

      expected = points.select { |x, y| x.between?(x1, x2) && y.between?(y1, y2) }
      actual = tree.between(x1: x1, y1: y1, x2: x2, y2: y2)

      assert_equal expected.sort, actual.sort,
        "failed for points=#{points.inspect} rect=[#{x1},#{x2},#{y1},#{y2}]"
    end
  end
end
