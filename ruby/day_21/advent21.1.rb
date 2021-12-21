#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.
                   split("\n").
                   map { |line| /position: (\d+)/.match(line).captures.first.to_i }
end

class Dice
  attr_reader :rolls

  def initialize
    @state = (1..100).to_a.cycle
    @rolls = 0
  end

  def next
    @state.next.tap { @rolls += 1 }
  end
end

def play(positions)
  dice = Dice.new
  scores = [0, 0]
  current_player = 0
  until(scores.any? { |score| score >= 1000 })
    pos = positions[current_player]
    new_pos = ((3.times.map { dice.next }.sum + pos) % 10)
    scores[current_player] += new_pos.zero? ? 10 : new_pos
    positions[current_player] = new_pos
    current_player = (current_player + 1) % 2
  end
  dice.rolls * scores.min
end

if __FILE__ == $0
  p play(input)
end
