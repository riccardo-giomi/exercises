class BalancedKdTree
  class Median
    class << self
      def slice_by_median(values, axis:)
        size = values.size
        median_rank = find_rank(size / 2, values, axis:)

        [
          values[0...median_rank],       # left_values
          [values[median_rank]],         # median_values
          values[median_rank + 1...size] # right_values
        ]
      end

      def find_rank(target, values, low = 0, high = values.size - 1, axis:)
        # ranks contain the start and finish indexes of ties. For a single
        # rank result they have the same value (e.g. 2-way's rank = 1 -> ranks
        # = [1,1])
        left, right = three_way_partition(values, low, high, axis:)

        # Ensure we keep ties on the right side 
        return left if target.between?(left, right)

        if target < left
          find_rank(target, values, low, left - 1, axis:)
        else
          find_rank(target, values, right + 1, high, axis:)
        end
      end

      def three_way_partition(values, low, high, axis:)
        left = i = low
        right = pivot = high
        pivot_value = values[pivot][axis]

        while i <= right
          value = values[i][axis]

          if value < pivot_value
            values[i], values[left] = values[left], values[i]
            i += 1
            left += 1
          elsif value > pivot_value
            values[i], values[right] = values[right], values[i]
            right -= 1
          else
            i += 1
          end
        end
        [left, right]
      end
    end
  end

  def initialize(values)
    @tree = build(values)
  end

  def between(x1:, y1:, x2:, y2:, tree: @tree, depth: 0)
    return [] if tree.nil?

    axis = axis(depth)
    results = []
    node, left, right = tree

    results << node if check_node?(node, x1:, y1:, x2:, y2:)

    if check_left?(node, x1:, y1:, axis:)
      results.concat(between(x1:, y1:, x2:, y2:, tree: left, depth: depth + 1))
    end

    if check_right?(node, x2:, y2:, axis:)
      results.concat(between(x1:, y1:, x2:, y2:, tree: right, depth: depth + 1))
    end

    results
  end

  def inspect
    "#<BalancedKdTree k=2 " + (@tree.nil? ? "Empty" : @tree.inspect) + ">"
  end

  private

  def axis(depth)
    depth % 2
  end

  def build(values, depth: 0)
    return nil if values.empty?

    left_values, median_values, right_values = Median.slice_by_median(values.dup, axis: axis(depth))

    [
      median_values.first,                   # node (value)
      build(left_values, depth: depth + 1),  # left sub-tree
      build(right_values, depth: depth + 1)  # right sub-tree
    ]
  end

  def check_node?(node, x1:, y1:, x2:, y2:)
      node[0].between?(x1, x2) && node[1].between?(y1, y2)
  end

  def check_left?(node, x1:, y1:, axis:)
    axis.zero? ? (node[0] > x1) : (node[1] > y1)
  end

  def check_right?(node, x2:, y2:, axis:)
    axis.zero? ? (node[0] <= x2) : (node[1] <= y2)
  end
end

require "minitest/autorun"

class BalancedKdTreeTest < Minitest::Test
  POINTS = [[5, 4], [2, 3], [8, 1], [9, 6], [4, 7], [7, 2]].freeze

  def setup
    @tree = BalancedKdTree.new(POINTS)
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
    tree = BalancedKdTree.new([[1, 1]])
    assert_equal [[1, 1]], tree.between(x1: 0, y1: 0, x2: 2, y2: 2)
    assert_equal [], tree.between(x1: 5, y1: 5, x2: 6, y2: 6)
  end

  def test_query_with_duplicate_axis_value_at_split_boundary
    # regression: quickselect settled one of the two x=0 points into
    # left_values despite it tying the median's own x value, so a query
    # with x1 exactly at that tied value pruned it away incorrectly
    points = [[18, -39], [26, -18], [-26, 32], [-38, 1], [36, -8], [0, -26],
              [33, -7], [-46, 47], [0, -10], [19, -34], [5, -15], [-29, -50],
              [8, 5], [-5, 27], [-22, 25]]
    tree = BalancedKdTree.new(points)

    result = tree.between(x1: 0, y1: -39, x2: 21, y2: 40)
    assert_equal [[0, -26], [0, -10], [5, -15], [8, 5], [18, -39], [19, -34]],
      result.sort
  end

  def test_query_with_duplicate_axis_value_at_split_boundary_2
    points = [[21, 22], [-44, 20], [-47, 40], [13, 42], [11, -26], [44, 21],
              [34, 46], [-18, -22], [31, -44], [-31, -38], [28, -41],
              [-26, 35], [16, 4], [-17, 4], [28, 22], [49, 41], [39, 42],
              [12, -7], [-38, 48], [-48, -23], [-24, -5], [-22, -45],
              [20, 35], [26, 50], [-21, -10], [-15, 20], [17, -9],
              [-18, -16], [9, 14], [-38, -11], [-7, -13], [-45, 38],
              [47, 45], [-47, 18], [5, 20], [39, 25], [43, -34], [40, 15],
              [-3, 7]]
    tree = BalancedKdTree.new(points)

    result = tree.between(x1: -18, y1: -42, x2: 43, y2: 3)
    assert_equal [[-18, -22], [-18, -16], [-7, -13], [11, -26], [12, -7],
                  [17, -9], [28, -41], [43, -34]],
      result.sort
  end

  def test_stress_against_naive_scan
    200.times do
      points = Array.new(rand(1..40)) { [rand(-50..50), rand(-50..50)] }
      tree = BalancedKdTree.new(points)

      x1, x2 = [rand(-50..50), rand(-50..50)].sort
      y1, y2 = [rand(-50..50), rand(-50..50)].sort

      expected = points.select { |x, y| x.between?(x1, x2) && y.between?(y1, y2) }
      actual = tree.between(x1: x1, y1: y1, x2: x2, y2: y2)

      assert_equal expected.sort, actual.sort,
        "failed for points=#{points.inspect} rect=[#{x1},#{x2},#{y1},#{y2}]"
    end
  end
end

