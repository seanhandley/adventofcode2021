#!/usr/bin/env ruby

require_relative "./advent9.1"
require "colorize"

def basin(i, j, used = [])
  return [] if used.include?([i, j]) || input[i][j] == 9

  used << [i, j]

  res = []

  res << [i - 1, j] if i > 0 && input[i - 1][j] != 9
  res << [i + 1, j] if i < input.length - 1 && input[i + 1][j] != 9
  res << [i, j - 1] if j > 0 && input[i][j - 1] != 9
  res << [i, j + 1] if j < input.first.length - 1 && input[i][j + 1] != 9

  [[i, j]] + res.map do |a, b|
    basin(a, b, used)
  end.reduce(:+)
end

def basins
  basins = []
  coordinates = []
  input.each_with_index do |rows, i|
    rows.each_with_index do |_cols, j|
      next if coordinates.include?([i, j])
      b = basin(i, j)
      basins << b
      coordinates += b
    end
  end
  basins.reject(&:empty?).sort_by(&:length)
end

def colors
  String.colors.reject { |c| [:white, :black, :default].include?(c) }.shuffle.cycle
end

def gradient(num)
  {
    "0" => :black,
    "1" => :blue,
    "2" => :light_blue,
    "3" => :cyan,
    "4" => :light_cyan,
    "5" => :light_yellow,
    "6" => :yellow,
    "7" => :light_magenta,
    "8" => :magenta,
    "9" => :red
  }[num]
end

def print_out
  output = input.map { |row| row.map(&:to_s) }
  basins.zip(colors).each do |basin, color|
    basin.each do |i, j|
      output[i][j] = "█".colorize(gradient(output[i][j]))
    end
  end
  output.each_with_index do |row, i|
    row.each_with_index do |col, j|
      output[i][j] = "█".colorize(gradient("9")) if output[i][j] == "9"
    end
  end
  output.each do |row|
    puts row.join
  end
end

if __FILE__ == $0
  p basins.last(3).map(&:length).reduce(:*)
  # print_out
end
