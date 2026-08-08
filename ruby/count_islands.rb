# countIslands
#
# Given a 2D grid of 1s (land) and 0s (water), count the number of islands. An
# island is formed by connecting adjacent land cells horizontally or vertically
# (not diagonally). Assume all four edges of the grid are surrounded by water.
#
# Example:
# grid = [
#   [1, 1, 0, 0, 0],
#   [1, 1, 0, 0, 0],
#   [0, 0, 1, 0, 0],
#   [0, 0, 0, 1, 1]
#


class Islands
  def initialize(grid)
    @grid = grid
    @h = grid&.size
    @w = grid&.first&.size
  end

  def count
    return nil if @h.nil? || @w.nil?
    return 0 if @w.zero?

    grid = @grid.map { |row| row.dup }

    count = 0
    (0...@w).each do |x|
      (0...@h).each do |y|
        if grid(x, y, grid) == 1
          count += 1
          dfs(x, y, grid)
        end
      end
    end
    count
  end

  def dfs(x,y, grid)
    return unless grid(x, y, grid) == 1
    grid[y][x] = 0
    [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |direction|
      dx = direction.first
      dy = direction.last
      dfs(x + dx, y + dy, grid)
    end
  end

  def grid(x, y, grid = @grid)
    # Out of bounds handled by returning 0 (grid surrouded by water)
    return 0 unless (0...@w).include?(x) && (0...@h).include?(y)
    grid[y][x]
  end
end

def count_islands(grid)
  Islands.new(grid).count
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
end

grid = [
  [1, 1, 0, 0, 0],
  [1, 1, 0, 0, 0],
  [0, 0, 1, 0, 0],
  [0, 0, 0, 1, 1]
]
check(count_islands(grid), 3)

 grid = [
   [1, 1, 1, 1, 1],
   [1, 0, 0, 0, 1],
   [1, 0, 1, 0, 1],
   [1, 0, 0, 0, 1],
   [1, 1, 1, 1, 1]
 ]
 check(count_islands(grid), 2)

 grid = []
 check(count_islands(grid), nil)

 grid = [[]]
 check(count_islands(grid), 0)

 grid = [[0]]
 check(count_islands(grid), 0)

 grid = [[1]]
 check(count_islands(grid), 1)

 grid = [[1, 0],
         [0, 1]]
 check(count_islands(grid), 2)

 grid = [[1, 0, 1]]
 check(count_islands(grid), 2)

 grid = [[1],
         [1],
         [0]]
 check(count_islands(grid), 1)
