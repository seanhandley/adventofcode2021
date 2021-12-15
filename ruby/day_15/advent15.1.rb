#!/usr/bin/env ruby

# --- Day 15: Chiton ---
# You've almost reached the exit of the cave, but the walls are getting closer together. Your submarine can barely still fit, though; the main problem is that the walls of the cave are covered in chitons, and it would be best not to bump any of them.
#
# The cavern is large, but has a very low ceiling, restricting your motion to two dimensions. The shape of the cavern resembles a square; a quick scan of chiton density produces a map of risk level throughout the cave (your puzzle input). For example:
#
# 1163751742
# 1381373672
# 2136511328
# 3694931569
# 7463417111
# 1319128137
# 1359912421
# 3125421639
# 1293138521
# 2311944581
#
# You start in the top left position, your destination is the bottom right position, and you cannot move diagonally. The number at each position is its risk level; to determine the total risk of an entire path, add up the risk levels of each position you enter (that is, don't count the risk level of your starting position unless you enter it; leaving it adds no risk to your total).
#
# Your goal is to find a path with the lowest total risk. In this example, a path with the lowest total risk is highlighted here:
#
# 1163751742
# 1381373672
# 2136511328
# 3694931569
# 7463417111
# 1319128137
# 1359912421
# 3125421639
# 1293138521
# 2311944581
#
# The total risk of this path is 40 (the starting position is never entered, so its risk is not counted).
#
# What is the lowest total risk of any path from the top left to the bottom right?

require "pqueue" # https://en.wikipedia.org/wiki/Priority_queue#Dijkstra's_algorithm
require "set"

def input
  @input ||= STDIN.read.
               split("\n").
               map { |line| line.chars.map(&:to_i) }
end

def each_neighbour(grid, (x, y))
  yield [x - 1, y] if x > 0
  yield [x + 1, y] if x + 1 < grid[y].size
  yield [x, y - 1] if y > 0
  yield [x, y + 1] if y + 1 < grid.size
end

def find_path(grid)
  start = [0, 0]
  finish = [grid[0].size - 1, grid.size - 1]

  visited = Set.new
  queue = PQueue.new([[start, 0]]) { |a, b| a.last < b.last }

  until queue.empty?
    position, risk = queue.pop

    next unless visited.add?(position)
    return risk if position == finish

    each_neighbour(grid, position) do |x, y|
      queue.push([[x, y], risk + grid[y][x]])
    end
  end
end

if __FILE__ == $0
  puts find_path(input)
end
