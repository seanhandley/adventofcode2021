#!/usr/bin/env ruby

require_relative "./advent13.2"
require "colorize"

def print_grid(a = nil, i = nil)
  f = @grid.dup
  if a && i
    case a
    when "x"
      f.each_with_index do |row, k|
        row.each_with_index do |_e, j|
          f[k][j] = "||" if j == i
        end
      end
    when "y"
      f[i] = f[i].map { |_e| "=" }
    end
  end
  print_in_ascii_square(f)
end

def color_picker
  @color_picker ||= String.colors.cycle
end

def print_in_ascii_square(grid)
  color = color_picker.next
  out = []
  bar = "+" + ("-" * (grid.first.length + 2)) + "+"
  out << bar
  grid.each do |row|
    out << "| " + row.map { |c| c == SOLID ? SOLID.colorize(color) : c }.join + " |"
  end
  out << bar
  out.each do |row|
    puts row
  end
  puts
end

if __FILE__ == $0
  setup_grid
  print_grid
  folding_instructions.each { |a, i| print_grid(a, i); fold(a, i) }
  print_grid
end
