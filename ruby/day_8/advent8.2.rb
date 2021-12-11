#!/usr/bin/env ruby

require "set"

#  aaaa
# b    c
# b    c
#  dddd
# e    f
# e    f
#  gggg
#
@config = [
 # abc efg
  "1110111", # 0
 #   c  f
  "0010010", # 1
 # a cde g
  "1011101", # 2
 # a cd fg
  "1011011", # 3
 #  bcd f
  "0111010", # 4
 # ab d fg
  "1101011", # 5
 # ab defg
  "1101111", # 6
 # a c  f 
  "1010010", # 7
 # abcdefg
  "1111111", # 8
 # abcd fg
  "1111011"  # 9
]

def bin_to_alpha(bin)
  "abcdefg".chars.zip(bin.chars).select { |_c, b| b == "1" }.map { |c, _b| c }.join
end

def alpha_to_bin(alpha)
  "abcdefg".chars.map { |c| alpha.include?(c) ? "1" : "0" }.join
end

def rotate(bin, sequence)
  sequence.map { |i| bin.chars[i] }.join
end

def input
  @input ||= STDIN.read.split("\n").
               map { |line| line.split("|").map(&:split) }
end

# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
# fdgacbe cefdb cefbgd gcbe
def solve(input, output)
  (0..6).to_a.permutation.each do |sequence|
    cipher = @config.map { |c| rotate(c, sequence) }.map(&method(:bin_to_alpha)).map { |e| e.chars.sort.join }
    if cipher.to_set == input.map { |e| e.chars.sort.join }.to_set
      nums = @config.map { |e| bin_to_alpha(e) }.
        map { |e| bin_to_alpha(rotate(alpha_to_bin(e), sequence)) }
      return output.map { |o| nums.each_with_index.detect { |e, i| e.chars.to_set == o.chars.to_set } }.map(&:last).join.to_i
    end
  end
end

def result
  input.map { |input, output| solve(input, output) }.sum
end

if __FILE__ == $0
  p result
end
