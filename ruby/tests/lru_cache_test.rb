require "minitest/autorun"
require_relative "../lru_cache"

class LRUCacheTest < Minitest::Test
  def setup
    @cache = LRUCache.new(2)
  end

  def test_get_on_missing_key_returns_nil
    assert_nil @cache.get(1)
  end

  def test_put_returns_the_value
    assert_equal "a", @cache.put(1, "a")
  end

  def test_get_returns_previously_put_value
    @cache.put(1, "a")
    assert_equal "a", @cache.get(1)
  end

  def test_put_evicts_least_recently_used_on_overflow
    @cache.put(1, "a")
    @cache.put(2, "b")
    @cache.get(1)          # touch 1, so 2 becomes least-recently-used
    @cache.put(3, "c")     # evicts 2

    assert_nil @cache.get(2)
    assert_equal "a", @cache.get(1)
    assert_equal "c", @cache.get(3)
  end

  def test_put_on_existing_key_updates_value_and_touches_it
    @cache.put(1, "a")
    @cache.put(2, "b")
    @cache.put(1, "updated") # touches 1, so 2 becomes least-recently-used
    @cache.put(3, "c")       # evicts 2

    assert_nil @cache.get(2)
    assert_equal "updated", @cache.get(1)
    assert_equal "c", @cache.get(3)
  end
end
