#!/usr/bin/env ruby

# --- Part Two ---
#
# Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:
#
# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
# cdfeb fcadb cdfeb cdbaf
# After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:
#
#  dddd
# e    a
# e    a
#  ffff
# g    b
# g    b
#  cccc
#
# So, the unique signal patterns would correspond to the following digits:
#
# acedgfb: 8
# cdfbe: 5
# gcdfa: 2
# fbcad: 3
# dab: 7
# cefabd: 9
# cdfgeb: 6
# eafb: 4
# cagedb: 0
# ab: 1
#
# Then, the four digits of the output value can be decoded:
#
# cdfeb: 5
# fcadb: 3
# cdfeb: 5
# cdbaf: 3
#
# Therefore, the output value for this entry is 5353.
#
# Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:
#
# fdgacbe cefdb cefbgd gcbe: 8394
# fcgedb cgb dgebacf gc: 9781
# cg cg fdcagb cbg: 1197
# efabcd cedba gadfec cb: 9361
# gecf egdcabf bgf bfgea: 4873
# gebdcfa ecba ca fadegcb: 8418
# cefg dcbef fcge gbcadfe: 4548
# ed bcgafe cdgba cbgef: 1625
# gbdfcae bgc cg cgb: 8717
# fgae cfgab fg bagce: 4315
#
# Adding all of the output values in this larger example produces 61229.
#
# For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?

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
