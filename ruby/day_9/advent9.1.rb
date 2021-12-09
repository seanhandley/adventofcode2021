#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.
               split("\n").
               map { |line| line.chars.map(&:to_i) }
end

def neighbours(i, j)
  res = []
  res << input[i - 1][j] if i > 0
  res << input[i + 1][j] if i < input.length - 1
  res << input[i][j - 1] if j > 0
  res << input[i][j + 1] if j < input.first.length - 1
  res
end

def risks
  out = []
  input.each_with_index do |row, i|
    row.each_with_index do |col, j|
      v = input[i][j]
      n = neighbours(i, j)
      out << (1 + v) if neighbours(i, j).all? { |e| e > v }
    end
  end
  out
end

if __FILE__ == $0
  p risks.sum
end
