#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.split("\n").map(&method(:snail_parse))
end

def snail_parse(str)
  counter = 0
  output = []
  str.chars.each do |char|
    if char.match?(/\d/)
      output << char.to_i + counter.i
    elsif char == "["
      counter += 1
    elsif char == "]"
      counter -= 1
    end
  end
  output
end

def explode(arr, ind)
  first, second = arr.slice(ind, 2)
  arr[ind - 1] += first.real if ind != 0
  arr[ind + 2] += second.real if arr[ind + 2]
  arr.delete_at(ind)
  arr[ind] = 0 + (first.imaginary - 1).i
end

def split(arr, ind)
  arr.insert(ind + 1, (arr[ind].real / 2.0).round + (arr[ind].imaginary + 1).i)
  arr[ind] = arr[ind].real / 2 + (arr[ind].imaginary + 1).i
end

def magnitude(arr)
  loop do
    max_depth = arr.map(&:imaginary).max
    break if max_depth == 0
    ind = arr.index { |e| e.imaginary == max_depth }
    arr[ind] = 3 * arr[ind].real + 2 * arr[ind + 1].real + (arr[ind].imaginary - 1).i
    arr.delete_at(ind + 1)
  end
  arr.first.real
end

def snail_add(a, b)
  joined = a.dup.concat(b).map { |e| e + 1.i }
  loop do 
    index_to_explode = joined.index { |e| e.imaginary >= 5}
    if index_to_explode
      explode(joined, index_to_explode) and next
    end
    index_to_split = joined.index { |e| e.real >= 10 }
    if index_to_split
      split(joined, index_to_split) and next
    end
    break
  end
  joined
end

if __FILE__ == $0
  puts magnitude(input.reduce { |a, b| snail_add(a, b) })
end
