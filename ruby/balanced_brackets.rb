# for i in 0...string.length
#   if string[i] in "([{"
#     queue.push string[i]
#   elsif string[i] in "}])"
#     if queue.pop != inverse_bracket(string[i])
#       return false
# return queue.size == 0

def balanced?(string)
  queue = []
  brackets = { "(" => ")", "[" => "]", "{" => "}" }

  (0...string.length).each do |i|
    char = string[i]
    if brackets.keys.include?(char) # ([{
      queue.push(char)
    elsif brackets.values.include?(char) # }])
      candidate = queue.pop
      return false unless char == brackets[candidate]
    end
  end

  return queue.size == 0
end

def check(actual, expected)
  status = actual == expected ? "SUCCESS" : "FAILURE"
  puts "#{status}: got=#{actual.inspect} wanted=#{expected.inspect}"
end

check(balanced?("a"), true)
check(balanced?("("), false)
check(balanced?("({[]})"), true)
check(balanced?("([)]"), false)
check(balanced?("a(b[c]d)e"), true)
check(balanced?("(()"), false)
check(balanced?(")("), false)
