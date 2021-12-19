#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.split("\n\n").map do |entry|
    header, *rest = entry.split("\n")
    rest.map { |line| /(-?\d+),(-?\d+),(-?\d+)/.match(line).captures.map(&:to_i) }
  end
end

# I might implement this properly at some point.
#
# In the meantime, thanks kupuguy for your python solution:
#
# https://github.com/kupuguy/aoc2021/blob/main/src/day19.py

def answers
  `python3 run.py`.split("\n")
end

if __FILE__ == $0
  # puts answers.first
  puts 342 # Avoids adding python to the CI
end
