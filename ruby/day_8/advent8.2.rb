#!/usr/bin/env ruby

#  aaaa
# b    c
# b    c
#  dddd
# e    f
# e    f
#  gggg
#
def num_to_bin(num)
  {
         # abcdefg
    0 => "1110111",
    1 => "0010010",
    2 => "1011101",
    3 => "1011011",
    4 => "0111010",
    5 => "1101011",
    6 => "1101111",
    7 => "1010010",
    8 => "1111111",
    9 => "1111011"
  }[num]
end

def bin_to_num(bin)
  {
   # abcdefg
    "1110111" => 0,
    "0010010" => 1,
    "1011101" => 2,
    "1011011" => 3,
    "0111010" => 4,
    "1101011" => 5,
    "1101111" => 6,
    "1010010" => 7,
    "1111111" => 8,
    "1111011" => 9
  }[bin]
end



@known_values = [2, 3, 4, 7]

def input
  @input ||= STDIN.readlines.
               map { |line| line.split("|").map(&:split) }
end

# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
# fdgacbe cefdb cefbgd gcbe
def solve(input, output)
  # output
  "abcdefg".chars.permutation.to_a.count
end

def result
  solve(*input.first)
end

if __FILE__ == $0
  # p result
end
