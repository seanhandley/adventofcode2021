#!/usr/bin/env ruby

require_relative "./advent9.2"
require "colorize"

def colors
  String.colors.reject { |c| [:white, :black, :default].include?(c) }.shuffle.cycle
end

def gradient(num)
  {
    0 => :black,
    1 => :blue,
    2 => :light_blue,
    3 => :cyan,
    4 => :light_cyan,
    5 => :light_yellow,
    6 => :yellow,
    7 => :light_magenta,
    8 => :magenta,
    9 => :red
  }[num]
end

def print_out
  output = @data.dup
  output.each_with_index do |row, i|
    row.each_with_index do |col, j|
      output[i][j] = "█".colorize(gradient(output[i][j][0]))
    end
  end
  output.each do |row|
    puts row.join
  end
end

if __FILE__ == $0
  mark_basins
  print_out
end
