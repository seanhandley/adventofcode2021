#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.
                   split("\n").
                   map { |line| /position: (\d+)/.match(line).captures.first.to_i - 1 }
end

class Game
  MAX_SCORE  = 21
  PLAYER_ONE = [0, 0, 1, 2, 3].freeze
  PLAYER_TWO = [1, 2, 3, 0, 1].freeze

  def initialize(starting_pos_a, starting_pos_b)
    @wins = [0, 0]
    @universes = { [starting_pos_a, 0, starting_pos_b, 0] => 1 }
  end

  def play
    while @universes.any?
      [PLAYER_ONE, PLAYER_TWO].each do |args|
        @universes = step(args)
      end
    end

    @wins.max
  end

  private

  def step(args)
    @universes.each_with_object(Hash.new(0)) do |(universe, universe_count), new_universes|
      dice_counts.each do |dice_args|
        calculate_score(universe, universe_count, new_universes, dice_args, args)
      end
    end
  end

  def calculate_score(universe, universe_count, new_universes, dice_args, args)
    dice_total, dice_count = *dice_args
    player, player_pos, player_score, other_pos, other_score = *args

    pos = (universe[player_pos] + dice_total) % 10
    score = universe[player_score] + pos + 1
    if score >= MAX_SCORE
      @wins[player] += dice_count * universe_count
    else
      key = []
      key[player_pos] = pos
      key[player_score] = score
      key[other_pos] = universe[other_pos]
      key[other_score] = universe[other_score]
      new_universes[key] += dice_count * universe_count
    end
  end

  def dice_counts
    @dice_counts ||= [1, 2, 3].repeated_permutation(3).
                               map(&:sum).
                               tally
  end
end

if __FILE__ == $0
  p Game.new(*input).play
end
