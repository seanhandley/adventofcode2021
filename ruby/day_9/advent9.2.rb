#!/usr/bin/env ruby

# --- Part Two ---
# Next, you need to find the largest basins so you know what areas are most important to avoid.
#
# A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.
#
# The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.
#
# The top-left basin, size 3:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# The top-right basin, size 9:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# The middle basin, size 14:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# The bottom-right basin, size 9:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.
#
# What do you get if you multiply together the sizes of the three largest basins?

def input
  @input ||= STDIN.read.
               split("\n").
               map { |line| line.chars.map { |n| [n.to_i, nil]} }
end

@data = input.dup

def basin(i, j, id)
  return if @data[i][j][1] || @data[i][j][0] == 9

  @data[i][j][1] = id

  res = []

  res << [i - 1, j] if i > 0 && @data[i - 1][j][0] != 9
  res << [i + 1, j] if i < @data.length - 1 && @data[i + 1][j][0] != 9
  res << [i, j - 1] if j > 0 && @data[i][j - 1][0] != 9
  res << [i, j + 1] if j < @data.first.length - 1 && @data[i][j + 1][0] != 9

  res.each do |a, b|
    basin(a, b, id)
  end
end

def mark_basins
  id = 0
  @data.each_with_index do |rows, i|
    rows.each_with_index do |_cols, j|
      next if @data[i][j][1]
      basin(i, j, id)
      id += 1
    end
  end
end

if __FILE__ == $0
  mark_basins
  @counts = Hash.new(0)
  @data.each do |row|
    row.each do |col|
      @counts[col[1]] += 1 if col[1]
    end
  end
  p @counts.values.sort.last(3).reduce(:*)
end
