# Roster
#
# Player = Struct.new(:name, :score)
#
# class Roster
#   include Enumerable
#
#   def initialize(players)
#     @players = players
#   end
#
#   # you implement this
#   def each
#   end
# end
#
# Requirements:
# - Implement only each (yielding each Player in @players) — don't hand-roll
#   top, sort, select, etc. yourself; get them from Enumerable once each is
#   defined.
# - Using the Roster, write these as one-liners/short methods, backed by
#   inherited Enumerable methods rather than manual loops:
#   - top_scorer — the single highest-scoring player
#   - average_score — mean of all scores (float)
#   - above(threshold) — array of players with score > threshold, highest score first
#
# Example:
# r = Roster.new([Player.new("A", 10), Player.new("B", 25), Player.new("C", 15)])
# r.top_scorer.name     # => "B"
# r.average_score       # => 16.666...
# r.above(12).map(&:name) # => ["B", "C"]


Player = Struct.new(:name, :score)

class Roster
  include Enumerable

  def initialize(players)
    @players = players
  end

  def size
    @players.size
  end

  def each
    return enum_for(:each) unless block_given?
    @players.each { |p| yield p }
  end

  def top_scorer
    max_by(&:score)
  end

  def average_score
    sum { |p| p.score }.to_f / size
  end

  def above(score)
    find_all { |p| p.score > score }
      .sort_by { |p| -p.score }
  end
end
