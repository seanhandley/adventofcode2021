#!/usr/bin/env ruby

class ScannerImage
  def initialize(algorithm, pass=0)
    hash_default_value = if algorithm[0]
                           pass % 2 == 1
                         else
                           false
                         end

    @image = Hash.new(hash_default_value)
    @min_x = 0
    @min_y = 0
    @max_x = 0
    @max_y = 0
    @pass = pass
    @algorithm = algorithm
  end

  def mark_pixel(point, light_up)
    @max_x = [@max_x, point.x].max
    @max_y = [@max_y, point.y].max

    @min_x = [@min_x, point.x].min
    @min_y = [@min_y, point.y].min

    @image[point] = light_up
  end

  def enhance
    new_image = ScannerImage.new(@algorithm, @pass + 1)
    start_x = @min_x - 1
    end_x = @max_x + 1

    start_y = @min_y - 1
    end_y = @max_y + 1

    start_x.upto(end_x) do |x|
      start_y.upto(end_y) do |y|
        point = Point.new(x, y)
        algo_pos = index(point)
        new_image.mark_pixel(point, @algorithm[algo_pos])
      end
    end

    new_image
  end

  def index(point)
    points = [
      Point.new(point.x - 1, point.y - 1),
      Point.new(point.x - 1, point.y),
      Point.new(point.x - 1, point.y + 1),

      Point.new(point.x,     point.y - 1),
      Point.new(point.x,     point.y),
      Point.new(point.x,     point.y + 1),

      Point.new(point.x + 1, point.y - 1),
      Point.new(point.x + 1, point.y),
      Point.new(point.x + 1, point.y + 1)
    ]

    points.map { |point| @image[point] ? '1' : '0' }.join.to_i(2)
  end

  def lit_pixel_count
    @image.values.count(&:itself)
  end

  class Point
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      x == other.x && y == other.y
    end

    def hash
      x.hash + y.hash
    end

    alias eql? ==
  end
end

def input
  @input ||= STDIN.read.split("\n\n")
end

def algorithm
  input.first.chars.map { |char| char == '#' }
end

def initial_image
  input.last.split("\n").map(&:chars)
end

def build_image
  image = ScannerImage.new(algorithm)

  initial_image.each_with_index do |row, x|
    row.each_with_index do |char, y|
      image.mark_pixel(ScannerImage::Point.new(x, y), (char == '#'))
    end
  end
  image
end

def lit_pixel_count(enhancement_count)
  image = build_image

  enhancement_count.times do
    image = image.enhance
  end

  image.lit_pixel_count
end

if __FILE__ == $0
  puts lit_pixel_count(2)
end
