#!/usr/bin/env ruby

# --- Day 4: Giant Squid ---
# You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.
#
# Maybe it wants to play bingo?
#
# Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)
#
# The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:
#
# 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
#
# 22 13 17 11  0
#  8  2 23  4 24
# 21  9 14 16  7
#  6 10  3 18  5
#  1 12 20 15 19
#
#  3 15  0  2 22
#  9 18 13 17  5
# 19  8  7 25 23
# 20 11 10 24  4
# 14 21 16 12  6
#
# 14 21 17 24  4
# 10 16 15  9 19
# 18  8 23 26 20
# 22 11 13  6  5
#  2  0 12  3  7
#
# After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):
#
# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
#
# After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:
#
# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
#
# Finally, 24 is drawn:
#
# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
#
# At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).
#
# The score of the winning board can now be calculated. Start by finding the sum of all undrawn numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.
#
# To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?

module Bingo
  class GameBuilder
    def initialize(input = STDIN.read)
      @input ||= input
    end

    def build
      Game.new(boards, number_sequence)
    end

    private

    def boards
      raw_boards.map(&Board.method(:new))
    end

    def number_sequence
      @input.split("\n").
        first.
        split(",").
        map(&:to_i)
    end

    private

    def raw_boards
      @input[2..].
        split("\n\n").
        map do |board| 
          board.split("\n").
            map(&:split).
            map { |row| row.map(&:to_i) } 
        end
    end
  end

  class Game
    def initialize(boards, number_sequence)
      @boards = boards
      @number_sequence = number_sequence
    end

    def scores
      @scores ||= number_sequence.each_with_object([]) do |number, scores|
        boards.reject(&:won?).each do |board|
          board.draw!(number)
          scores << board.score if board.won?
        end
      end
    end

    private

    attr_reader :boards, :number_sequence
  end

  class Board
    def initialize(input)
      @squares = input.map do |row|
        row.map(&Square.method(:new))
      end
      @last_number_drawn = nil
    end

    def draw!(number)
      @last_number_drawn = number
      @squares.each do |row|
        row.each do |square|
          square.draw!(number)
        end
      end
    end

    def won?
      !!score
    end

    def score
      return unless winning_line?

      @last_number_drawn * undrawn_numbers.sum
    end

    private

    def winning_line?
      [@squares, @squares.transpose].detect do |lines|
        lines.any? { |line| line.all?(&:drawn?) }
      end
    end

    def undrawn_numbers
      @squares.flatten.
        reject(&:drawn?).
        map(&:number)
    end

    class Square
      attr_reader :number, :drawn
      alias_method :drawn?, :drawn

      def initialize(number)
        @number = number
        @drawn = false
      end

      def draw!(number)
        @drawn = true if number == @number
      end
    end

    private_constant :Square
  end

  private_constant :Board
  private_constant :Game
end

@game = Bingo::GameBuilder.new.build

if __FILE__ == $0
  puts @game.scores.first
end
