# Implement a class that renders tree structures as ascii art.
#
# Assume only binary or ternary trees, the tree is represented as an Array.
# Use #inspect to render the node's content.
#
module PrettyTreeTernary
  # An anchor is where lines point to, they might take a different path but lines start 
  class Box < Struct.new(:lines, :width, :anchor, :empty)
    def self.leaf(label, empty: false)
      self.new([label], label.size, label.size / 2, empty)
    end

    def height = lines.size
    def empty? = !!empty
  end

  class Renderer
    GAP = 1
    MIN_LEAF_SIZE = 3 # Required to allow space for connector symbols
    MIN_BINARY_LEAF_SIZE = 5 # Binary leaves require more space for connector symbols
    MAX_LABEL_WIDTH = 12

    def box_for(tree, parent_arity: 1)
      return Box.leaf(format_label(nil, parent_arity:), empty: true) if tree.nil?

      children = tree[1...]
      raise "Invalid tree, only binary and ternary trees are supported." if children.size > 3
      # Visit all children, merge getting back from the recursion
      child_boxes = children.map { |node| box_for(node, parent_arity: children.size) }
      node_box(tree.first, child_boxes, parent_arity:)
    end

    private

    def node_box(label, child_boxes, parent_arity:)
      label = format_label(label, parent_arity:)

      if child_boxes.all?(&:empty?)
        return Box.leaf(label)
      end

      lines, width, offsets = merge_children(child_boxes)

      anchor = label_anchor_for(offsets)
      lines, width, offsets, anchor = pad_merged_children_horizontally(lines, width, offsets, anchor, label.length)

      label_line = render_label_line(label, width, anchor)
      connector_lines  = render_connector_lines(label, anchor, child_boxes, offsets, width)

      new_lines = [label_line] + connector_lines + lines
      Box.new(lines: new_lines, width:, anchor:, empty: false)
    end

    def format_label(label, parent_arity:)
      text = label.nil? ? "" : label.inspect

      min_width = parent_arity == 2 ? MIN_BINARY_LEAF_SIZE : MIN_LEAF_SIZE
      text = text.center(min_width)

      text.size <= MAX_LABEL_WIDTH ? text : text[0, (MAX_LABEL_WIDTH - 3)] + "..."
    end

    def merge_children(boxes)
      height = boxes.map(&:height).max

      lines = Array.new(height) { "" }
      offsets = []
      boxes.each_with_index do |box, i|
        offsets << lines.first.length + box.anchor

        padded_lines(box, height).each_with_index do |line, j|
          lines[j] += line
          # Do not gap the last box
          lines[j] += " " * GAP unless i == boxes.size - 1
        end
      end

      [lines, lines.first.length, offsets]
    end

    def label_anchor_for(offsets)
      case offsets.size
      when 1 then offsets.first
      when 2 then (offsets.last - offsets.first) - 1
      else offsets[1]
      end
    end

    # Ensures that the box created by merging the children subtrees is not
    # smaller than the parent label, including the fact that the label does not
    # start from the beginning of its line.
    def pad_merged_children_horizontally(lines, width, offsets, anchor, label_length)
      label_left  = label_length / 2
      label_right = label_length - label_left

      left_pad  = [label_left - anchor, 0].max
      anchor   += left_pad
      right_pad = [anchor + label_right - (width + left_pad), 0].max

      return [lines, width, offsets, anchor] if left_pad.zero? && right_pad.zero?

      lines = lines.map { |line| (" " * left_pad) + line + (" " * right_pad) }
      [lines, width + left_pad + right_pad, offsets.map { |o| o + left_pad }, anchor]
    end

    def render_label_line(label, width, anchor)
      label_start = anchor - label.length / 2
      line = " " * width
      line[label_start, label.length] = label
      line
    end

    def render_connector_lines(parent_label, parent_anchor, boxes, offsets, width)
      lines = Array.new(2) { " " * width }

      case boxes.size
      when 1
        unless boxes.first.empty?
          lines = render_middle_branch(lines, offsets.first)
        end
      when 2
        unless boxes.first.empty?
          lines = render_left_branch(lines, parent_label, parent_anchor, offsets)
        end
        unless boxes.last.empty?
          lines = render_right_branch(lines, parent_label, parent_anchor, offsets)
        end
      else # boxes.size == 3
        unless boxes.first.empty?
          lines = render_left_branch(lines, parent_label, parent_anchor, offsets)
        end
        unless boxes[1].empty?
          lines = render_middle_branch(lines, offsets[1])
        end
        unless boxes.last.empty?
          lines = render_right_branch(lines, parent_label, parent_anchor, offsets)
        end
      end

      lines
    end

    def render_left_branch(lines, parent_label, parent_anchor, offsets)
      anchor = offsets.first
      first_parent_label_char = parent_anchor - parent_label.length / 2
      labels_distance = first_parent_label_char - (anchor + 2)
      anchors_distance = parent_anchor - (anchor + 2)

      if labels_distance > 1
        lines[0][anchor + 2, anchors_distance + 1] = "_" * anchors_distance  + "|"
      else
        lines[0][anchor + 2] = "/"
      end
      lines[1][anchor + 1] = "/"

      lines
    end

    def render_middle_branch(lines, anchor)
      lines[0][anchor] = "|"
      lines[1][anchor] = "|"

      lines
    end

    def render_right_branch(lines, parent_label, parent_anchor, offsets)
      anchor = offsets.last
      last_parent_label_char = parent_anchor + parent_label.length / 2
      anchors_distance = anchor - 2 - parent_anchor
      labels_distance = (anchor - 2) - last_parent_label_char
      if labels_distance > 1
        lines[0][parent_anchor, anchors_distance + 1] = "|" + "_" * anchors_distance
      else
        lines[0][anchor - 2] = "\\"
      end
      lines[1][anchor - 1] = "\\"

      lines
    end

    def padded_lines(box, height)
      return box.lines if box.height == height

      padding = Array.new(height - box.height) { " " * box.width }
      box.lines + padding
    end
  end

  class << self
    def print(tree)
      puts render(tree)
    end

    def render(tree)
      Renderer.new.box_for(tree).lines.join("\n")
    end
  end
end


def test(tree)
  puts
  puts tree.inspect
  puts
  puts PrettyTreeTernary.print(tree)
  puts
end

test(nil)
test(["a"])
test(["morethan10chars"])
test([1, [2, nil, nil]])
test([1, [2, [3, nil, nil]]])
test(["a", ["b", nil, nil], nil])
test(["a", nil, ["c", nil, nil]])
test(["a", ["b", nil, nil], ["c", nil, nil]])
test([1, [2, [3, [4]]], [5, [6]]])
test(["a", ["b", nil, nil], ["c", nil, nil], ["d", nil, nil]])
test([1, ["a", ["b", nil, nil], ["c", nil, nil], ["d", nil, nil] ], nil])
test([1, nil, ["a", ["b", nil, nil], ["c", nil, nil], ["d", nil, nil]]])
test([1, nil, ["a", ["b", nil, nil], ["c", nil, nil], ["d", nil, nil]], nil])
test([123456789012, [2, nil, nil], [6, nil, nil], [7, nil, nil]])
test([1, ["a", ["b", nil, nil], ["c", nil, nil]], ["d", ["e", nil, nil], ["f", nil, nil]]])
test([1, ["a", ["b", nil, nil], ["c", nil, nil], ["d", nil, nil] ], ["e", ["f", nil, nil], ["g", nil, nil], ["h", nil, nil] ]])
test([1, [2,  [3, nil, nil],  [4, nil, nil], [5, nil, nil]  ], [6,  [7, nil, nil],  [8, nil, nil], [9, nil, nil]  ], [10, [11, nil, nil], [12, nil, nil], [13, nil, nil]]])
test([1, [2,  nil, nil], [6,  [7, nil, nil],  [8, nil, nil], [9, nil, nil]  ], [10, [11, nil, nil], [12, nil, nil], [13, nil, nil]]])
test([1337, ["aaaa", ["bbbb", nil, nil], ["cccc", nil, nil], ["dddd", nil, nil] ], ["eeee", ["ffff", nil, nil], ["gggg", nil, nil], ["hhhh", nil, nil] ]])
test(["a" * 1, ["b" * 10, nil, nil], ["c" * 10, nil, nil]])
test(["a" * 10, ["b" * 10, nil, nil], ["c" * 10, nil, nil]])
test(["a" * 1, ["b" * 10, ["c" * 10, nil, nil], ["d" * 10, nil, nil]], ["e" * 10, ["f" * 10, nil, nil], ["g" * 10, nil, nil]]])
test(["a" * 10, ["b" * 10, ["c" * 10, nil, nil], ["d" * 10, nil, nil]], ["e" * 10, ["f" * 10, nil, nil], ["g" * 10, nil, nil]]])
test(["root", ["leftlongsubtree", ["a", nil, nil], ["b", nil, nil]], ["r", nil, nil]])
test(["root", ["l", nil, nil], ["rightlongsubtree", ["a", nil, nil], ["b", nil, nil]]])
test(["root", ["leftlongsubtree", ["a", nil, nil], ["b", nil, nil]], ["m", nil, nil], ["rightlongsubtree", ["c", nil, nil], ["d", nil, nil]]])
test([786494, ["dvy", nil, nil, ["", nil, [true, nil, nil], ["cmv", nil]]]])
