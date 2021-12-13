#!/usr/bin/env ruby

# --- Day 13: Transparent Origami ---
# You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of time which caves are too hot to safely enter.
#
# Fortunately, the submarine seems to be equipped with a thermal camera! When you activate it, you are greeted with:
#
# Congratulations on your purchase! To activate this infrared thermal imaging
# camera system, please enter the code found on page 1 of the manual.
#
# Apparently, the Elves have never used this feature. To your surprise, you manage to find the manual; as you go to open it, page 1 falls out. It's a large sheet of transparent paper! The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input). For example:
#
# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0
#
# fold along y=7
# fold along x=5
#
# The first section is a list of dots on the transparent paper. 0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward. So, the coordinate 3,0 is to the right of 0,0, and the coordinate 0,7 is below 0,0. The coordinates in this example form the following pattern, where # is a dot on the paper and . is an empty, unmarked position:
#
# ...#..#..#.
# ....#......
# ...........
# #..........
# ...#....#.#
# ...........
# ...........
# ...........
# ...........
# ...........
# .#....#.##.
# ....#......
# ......#...#
# #..........
# #.#........
#
# Then, there is a list of fold instructions. Each instruction indicates a line on the transparent paper and wants you to fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines). In this example, the first fold instruction is fold along y=7, which designates the line formed by all of the positions where y is 7 (marked here with -):
#
# ...#..#..#.
# ....#......
# ...........
# #..........
# ...#....#.#
# ...........
# ...........
# -----------
# ...........
# ...........
# .#....#.##.
# ....#......
# ......#...#
# #..........
# #.#........
#
# Because this is a horizontal line, fold the bottom half up. Some of the dots might end up overlapping after the fold is complete, but dots will never appear exactly on a fold line. The result of doing this fold looks like this:
#
# #.##..#..#.
# #...#......
# ......#...#
# #...#......
# .#.#..#.###
# ...........
# ...........
#
# Now, only 17 dots are visible.
#
# Notice, for example, the two dots in the bottom left corner before the transparent paper is folded; after the fold is complete, those dots appear in the top left corner (at 0,0 and 0,1). Because the paper is transparent, the dot just below them in the result (at 0,3) remains visible, as it can be seen through the transparent paper.
#
# Also notice that some dots can end up overlapping; in this case, the dots merge together and become a single dot.
#
# The second fold instruction is fold along x=5, which indicates this line:
#
# #.##.|#..#.
# #...#|.....
# .....|#...#
# #...#|.....
# .#.#.|#.###
# .....|.....
# .....|.....
#
# Because this is a vertical line, fold left:
#
# #####
# #...#
# #...#
# #...#
# #####
# .....
# .....
#
# The instructions made a square!
#
# The transparent paper is pretty big, so for now, focus on just completing the first fold. After the first fold in the example above, 17 dots are visible - dots that end up overlapping after the fold is completed count as a single dot.
#
# How many dots are visible after completing just the first fold instruction on your transparent paper?

SOLID = "█".freeze
EMPTY = " ".freeze

def input
  @input ||= STDIN.read.split("\n\n")
end

def points
  input.first.split("\n").map { |line| line.split(",").map(&:to_i) }
end

def folding_instructions
  input.last.split("\n").map do |line|
    line.match(/fold along ([xy])=(\d+)/).captures
  end.map { |a, i| [a, i.to_i] }
end

def max_x
  folding_instructions.detect { |a, i| a == "x" }.last * 2
end

def max_y
  folding_instructions.detect { |a, i| a == "y" }.last * 2
end

def setup_grid
  @grid = Array.new(max_y + 1) { Array.new(max_x + 1) { EMPTY } }
  points.each do |x, y|
    @grid[y][x] = SOLID
  end
end

def sub_grid(g, a, b, c, d)
  (b..d).map do |y|
    (a..c).map do |x|
      g[y][x]
    end
  end
end

def merge(a, b)
  a.zip(b).map do |i, j|
    i.zip(j).map do |k, l|
      [k, l].any? {|e| e == SOLID } ? SOLID : EMPTY
    end
  end
end

def count_dots(g)
  g.flatten.count { |e| e == SOLID }
end

def fold(axis, index)
  case axis
  when "x"
    a = sub_grid(@grid,
                 0,
                 0,
                 index - 1,
                 @grid.length - 1)
    b = sub_grid(@grid, index + 1,
                 0,
                 @grid.first.length - 1,
                 @grid.length - 1).
                 transpose.
                 reverse.
                 transpose
    @grid = merge(a, b)
  when "y"
    a = sub_grid(@grid,
                 0,
                 0,
                 @grid.first.length - 1,
                 index - 1)
    b = sub_grid(@grid,
                 0,
                 index + 1,
                 @grid.first.length - 1,
                 @grid.length - 1).
                 reverse
    @grid = merge(a, b)
  end
end

if __FILE__ == $0
  setup_grid
  fold(*folding_instructions.first)
  p count_dots(@grid)
end
