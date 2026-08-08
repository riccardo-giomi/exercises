class InsertionPoint
  def initialize(values)
    @values = values
  end

  def find(target)
    left = 0
    right = @values.size - 1

    while left <= right
      middle = (left + right) / 2
      value = @values[middle]
      return middle if value == target
      if target > value
        left = middle + 1
      else
        right = middle - 1
      end
    end

    return left
  end

  def find_recursive(target, left = 0, right = @values.size - 1)
    return left if left > right

    middle = (left + right) / 2
    value = @values[middle]
    return middle if value == target

    if(target > value)
      find_recursive(target, middle + 1, right)
    else
      find_recursive(target, left, middle - 1)
    end
  end
end

def check(values, target, expected)
  o = InsertionPoint.new(values)
  puts "#find(#{values.inspect}, #{target.inspect}) # => #{expected.inspect}"
  actual = o.find(target)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
  puts "#recursive_find"
  actual = o.find_recursive(target)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status} got=#{actual.inspect} wanted=#{expected.inspect}"
  puts 
end

check([1], 1, 0)
check([1, 2, 3, 4], 5, 4)
check([2, 3, 4, 6], 5, 3)
check([1, 3, 4, 6, 9], 7, 4)
check([], 5, 0)
check([1, 3, 5, 6], 0, 0)
check([1, 3, 5, 6], 5, 2)
check([1, 3], 2, 1)
check([1, 3], 4, 2)
