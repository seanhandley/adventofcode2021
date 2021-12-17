#!/usr/bin/env ruby

REGEX = /target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/.freeze

def input
  @input ||= REGEX.match(STDIN.read).captures.map(&:to_i)
end

def x_min
  input[0]
end

def x_max
  input[1]
end

def y_min
  input[2]
end

def y_max
  input[3]
end

def overshot?(x, y)
  x > x_max || y < y_min
end

def hit?(x, y)
  [
    x <= x_max,
    x >= x_min,
    y <= y_max,
    y >= y_min
  ].all?
end

def fire!(x_velocity, y_velocity)
  x, y = 0, 0
  path = [[x, y]]
  until overshot?(x, y)
    x += x_velocity
    y += y_velocity
    path << [x, y]
    return [true, path] if hit?(x, y)
    x_velocity += (x_velocity.positive? ? -1 : 1) if x_velocity.nonzero?
    y_velocity -= 1
  end
  [false, path]
end

def hits
  hits = []
  (0..500).each do |x|
    300.downto(-300).each do |y|
      hit, path = fire!(x, y)
      hits << path if hit
    end
  end
  hits
end

if __FILE__ == $0
  puts hits.map { |path| path.map { |x, y| y }.max }.max
end
