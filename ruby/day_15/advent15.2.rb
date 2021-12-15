#!/usr/bin/env ruby

require_relative "./advent15.1"

def large_grid
  5.times.flat_map do |y|
    input.map do |row|
      5.times.flat_map do |x|
        row.map do |risk|
          new_risk = risk + y + x
          new_risk -= 9 while new_risk > 9
          new_risk
        end
      end
    end
  end
end

if __FILE__ == $0
  puts find_path(large_grid)
end