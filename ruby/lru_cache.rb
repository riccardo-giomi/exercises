class LRUCache
  def initialize(size)
    @size = size
    @cache = {}
  end

  def inspect
    "LRUCache[#{object_id}](#{@size}) #{@cache.inspect}"
  end

  def get(index)
    # avoid "re-adding" non existing values
    return nil unless @cache.has_key?(index)
    @cache[index] = @cache.delete(index)
  end

  def put(index, value)
    @cache.delete(index)
    @cache[index] = value
    evict if @cache.size > @size
    value
  end

  private

  def evict
    @cache.delete(@cache.keys.first)
  end
end

