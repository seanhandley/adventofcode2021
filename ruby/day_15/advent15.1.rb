#!/usr/bin/env ruby

require "pqueue"
require "set"

def input
  @input ||= STDIN.read.
               split("\n").
               map { |line| line.chars.map(&:to_i) }
end

def each_neighbour(grid, (x, y))
  yield [x, y - 1] if y > 0
  yield [x + 1, y] if x + 1 < grid[y].size
  yield [x, y + 1] if y + 1 < grid.size
  yield [x - 1, y] if x > 0
end


def find_path(grid)
  start = [0, 0]
  target = [grid[0].size - 1, grid.size - 1]

  visited = Set[]
  initial = [start, 0]
  queue = PQueue.new([initial]) { |a, b| a.last < b.last }

  until queue.empty?
    position, risk = queue.pop

    next unless visited.add?(position)
    return risk if position == target

    each_neighbour(grid, position) do |x, y|
      queue.push([[x, y], risk + grid[y][x]])
    end
  end
end

if __FILE__ == $0
  puts find_path(input)
end
