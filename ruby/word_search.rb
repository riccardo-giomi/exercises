class Grid
  def initialize(grid)
    @grid = grid
    @width = grid&.first&.size || 0
    @height = grid&.size || 0
  end

  def char(x, y)
    @grid[y][x]
  end

  #   for(x, y) in (0..word.first.size, 0..word.size):
  #     word.first == grid(x,y) -> (dfs?(x, y, 0) -> true)
  #   -> false
  def has?(word)
    @word = word
    (0...@width).each do |x|
      (0...@height).each do |y|
        if char(x,y) == @word[0] 
          @visited = Set.new
          return true if dfs?(x, y, 0)
        end
      end
    end
    false
  end

# dfs?(x, y, i):
#   x,y out of borders? -> false
#   grid(x, y) != word[i] -> false
#   visited?(x, y) -> false
#   if(i == word.size - 1) -> true
#
#   visited.add(x, y)
#   found = dfs(up) || dfs(down) || dfs(left) || dfs(right)
#   visited.remove(x, y)
#   -> found
#
# word_search(word):
#   for(x, y) in (0..word.first.size, 0..word.size):
#     word.first == grid(x,y) -> (dfs?(x, y, 0) -> true)
#   -> false

  def dfs?(x, y, i)
    return false if x < 0 || x >= @width || y < 0 || y >= @height
    return false if char(x, y) != @word[i]
    return false if @visited.include?([x, y])
    return true if i == @word.size - 1

    @visited.add([x, y])
    found = dfs?(x, y + 1 , i + 1) || dfs?(x, y - 1 , i + 1) || dfs?(x - 1, y , i + 1) || dfs?(x + 1, y , i + 1)
    @visited.delete([x, y])

    return found
  end
end

def word_search(grid, word)
  Grid.new(grid).has?(word)
end


def check(actual, expected)
  status = actual == expected ? "PASS" : "FAIL"
  puts "#{status}: got=#{actual.inspect} want=#{expected.inspect}"
end

grid = [
  ['A','B','C','E'],
  ['S','F','C','S'],
  ['A','D','E','E']
]
check(word_search([], "NOPE"), false) 
check(word_search([["A"]], "A"), true) 
check(word_search(grid, "ABCCED"), true) 
check(word_search(grid, "SEE"), true)    
check(word_search(grid, "ABCB"), false)   


