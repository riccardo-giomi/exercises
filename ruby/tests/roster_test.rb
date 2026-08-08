
require "minitest/autorun"
require_relative "../roster"

class RosterTest < Minitest::Test
  def setup
    @players = [Player.new("A", 15), Player.new("B", 25), Player.new("C", 10)]
    @roster = Roster.new(@players)
  end

  def test_top_scorer
    assert_equal "B", @roster.top_scorer.name
  end

  def test_average_score
    assert_in_delta 16.6, @roster.average_score, 0.1
  end

  def test_assert_above
    assert_equal ["B", "A"], @roster.above(12).map(&:name)
  end

  def test_includes_enumerable
    assert_includes Roster.ancestors, Enumerable
  end

  def test_each_yields_every_player_to_the_given_block
    names = []
    @roster.each { |p| names << p.name }
    assert_equal %w[A B C], names
  end

  def test_each_without_a_block_returns_an_enumerator
    enum = @roster.each
    assert_instance_of Enumerator, enum
    assert_equal %w[A B C], enum.map(&:name)
  end

  def test_enumerable_methods_work_directly_on_the_roster
    # exercises Enumerable methods derived from Roster#each itself,
    # not delegated straight to @players
    assert_equal %w[A B C], @roster.map(&:name)
    assert_equal @players[1], @roster.max_by(&:score)
    assert_equal [@players[1], @players[0]], @roster.select { |p| p.score > 12 }.sort_by { |p| -p.score }
  end
end
