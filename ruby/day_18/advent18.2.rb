#!/usr/bin/env ruby

require_relative "./advent18.1"

if __FILE__ == $0
  p input.permutation(2).map { |a, b| magnitude(snail_add(a, b)) }.max
end
