#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.split("\n").
               map { |line| line.split("|").map(&:split) }
end

#  aaaa
# b    c
# b    c
#  dddd
# e    f
# e    f
#  gggg
#
SEGMENTS = [
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
].freeze

def bin_to_alpha(bin)
  "abcdefg".chars.
    zip(bin.chars).
    select { |_c, b| b == "1" }.
    map { |c, _b| c }.
    join
end

def rotate(bin, sequence)
  sequence.map { |i| bin.chars[i] }.join
end

def ciphers
  @ciphers ||= (0..6).to_a.permutation.map { |sequence|
     [
       SEGMENTS.map { |c| rotate(c, sequence) }.
         map(&method(:bin_to_alpha)).
         map { |e| e.chars.sort.join }.sort,
       sequence
     ]
   }.to_h
end

def solve(input, output)
  cipher = input.map { |e| e.chars.sort.join }.sort
  sequence = ciphers[cipher]

  digits = SEGMENTS.map { |e| bin_to_alpha(rotate(e, sequence)) }

  output.map { |output_digit|
    digits.each_with_index.detect { |input_digit, i|
      input_digit.chars.sort == output_digit.chars.sort
    }
  }.map(&:last).
    join.
    to_i
end

def result
  input.map { |input, output| solve(input, output) }.sum
end

if __FILE__ == $0
  p result
end
