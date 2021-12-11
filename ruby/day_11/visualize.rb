#!/usr/bin/env ruby

require_relative "./advent11.2"

@sleep = 0.1

def print_octopuses
  system("clear")
  puts
  puts
  @octopuses.each do |row|
    puts "\t\t" + row.map { |octopus| octopus > 9 ? "🌟" : "🐙" }.join
  end
  sleep @sleep
end

if __FILE__ == $0
  @octopuses = input.dup
  loop do
    increase_brightness
    do_flashes
    print_octopuses if @octopuses.flatten.any? { |octopus| octopus > 9 }
    reset_octopuses
    if @octopuses.flatten.all? { |octopus| octopus == 0 }
      @sleep = 0.5
      print_octopuses
    end
  end
end
