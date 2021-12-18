#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.split("\n").map(&method(:eval))
end

def add(a, b)
  reduce([a, b])
end

# FULLY TESTED
def explodeable?(snail_number, level = 0)
  return true  if level > 4
  return false if snail_number.is_a?(Integer)
  [
    explodeable?(snail_number.first, level + 1),
    explodeable?(snail_number.last,  level + 1)
  ].any?
end

def destructure(snail_number, structure = [])
  return snail_number if snail_number.is_a?(Integer) || snail_number.all? { |e| e.is_a?(Integer) }

  structure << snail_number.first
  destructure(snail_number.first, structure)
  structure << snail_number.last
  destructure(snail_number.last, structure)

  structure
end

def restructure(structure)
  
end

# @found = nil

# def find_exploding_pair(snail_number)
#   return @found if @found
#   return snail_number if snail_number.is_a?(Integer)

#   res = [find_exploding_pair(snail_number.first), find_exploding_pair(snail_number.last)]

#   res.all? { |e| e.is_a?(Integer) } ? @found = res : res
# end

# def recursive_explode(snail_number)
#   return snail_number if snail_number.is_a?(Integer)

#   res = [recursive_explode(snail_number.first), recursive_explode(snail_number.last)]

#   if res.first.is_a?(Integer) && @found.first.is_a?(Integer)
#     [res.first + @found.first, res.last].tap { @found[0] = nil }
#   elsif res.last.is_a?(Integer) && @found.last.is_a?(Integer)
#     [res.first, res.last + @found.last].tap { @found[1] = nil }
#   else
#     res
#   end
# end

# def insert_zeroes(snail_number)
#   return 0 if snail_number.nil?
#   return snail_number if snail_number.is_a?(Integer)

#   [insert_zeroes(snail_number.first), insert_zeroes(snail_number.last)]
# end

# def explode(snail_number)
#   find_exploding_pair(snail_number)
#   # insert_zeroes(recursive_explode(snail_number))
#   @found.tap { @found = nil }
# end

# FULLY TESTED
def splittable?(snail_number)
  snail_number.flatten.any? { |e| e >= 10 }
end

# FULLY TESTED
def split(regular_number)
  [(regular_number / 2.0).floor, (regular_number / 2.0).ceil]
end

def reduce(snail_number)
  
end

# FULLY TESTED
def magnitude(snail_number)
  return snail_number if snail_number.is_a?(Integer)
  magnitude(snail_number.first) * 3 + magnitude(snail_number.last) * 2
end

if __FILE__ == $0
  # p explode([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])
  destructure([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]).each(&method(:p))
end
