#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.split("\n").
               map { |line| line.split("|").last }.
               map(&:split).
               map { |e| e.map(&:length) }
end

def result
  input.sum do |line|
    line.count { |c| [2, 3, 4, 7].include?(c) }
  end
end

if __FILE__ == $0
  p result
end
