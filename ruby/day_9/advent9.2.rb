#!/usr/bin/env ruby

require_relative "./advent9.1"
require "set"

def basin(i, j, used = Set.new)
  return Set.new if used.include?([i, j]) || input[i][j] == 9

  used << [i, j]

  res = Set.new

  res << [i - 1, j] if i > 0 && input[i - 1][j] != 9
  res << [i + 1, j] if i < input.length - 1 && input[i + 1][j] != 9
  res << [i, j - 1] if j > 0 && input[i][j - 1] != 9
  res << [i, j + 1] if j < input.first.length - 1 && input[i][j + 1] != 9

  Set.new([[i, j]]) + res + res.map do |a, b|
    basin(a, b, used)
  end.reduce(:+)
end

if __FILE__ == $0
  basins = []
  coordinates = Set.new
  input.each_with_index do |rows, i|
    rows.each_with_index do |_cols, j|
      next if coordinates.include?([i, j])
      b = basin(i, j)
      basins << b
      coordinates += b.to_a
    end
  end
  p basins.sort_by(&:length).last(3).map(&:length).reduce(:*)
end
