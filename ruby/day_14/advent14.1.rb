#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.split("\n\n")
end

def polymer_template
  input.first.chars
end

def insertion_rules
  input.last.
        split("\n").map { |line|
          [line.split(" -> ").first.chars, line.split(" -> ").last]
        }.to_h
end

def letter_tally(tally)
  tally.each_with_object(Hash.new(0)) { |(k, v), totals| totals[k.last] += v }
end

def initial_pair_tally
  polymer_template.each_cons(2).
    each_with_object(Hash.new(0)) { |(a, b), tally|
      tally[[a, b]] += 1
    }
end

def pair_tally(steps)
  pair_tally = initial_pair_tally
  steps.times do |i|
    old, pair_tally = pair_tally.dup, Hash.new(0)
    old.each do |(a, b), v|
      next_char = insertion_rules[[a, b]]
      pair_tally[[a, next_char]] += v
      pair_tally[[next_char, b]] += v
    end
  end
  pair_tally
end

def result(steps)
  letter_tally(pair_tally(steps)).tap do |tally|
    return tally.values.max - tally.values.min
  end
end

if __FILE__ == $0
  p result(10)
end
