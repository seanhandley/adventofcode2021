#!/usr/bin/env ruby

def input
  @input ||= STDIN.read.chars.map { |c| "%04d" % c.to_i(16).to_s(2) }.join.chars
end

def debug(m)
  p m if @debug
end

def parse_header
  [
    input[@pos, 3].join.to_i(2),
    input[@pos + 3, 3].join.to_i(2)
  ].tap { @pos += 6 }
end

def parse_literal
  debug "parsing literal"
  literal = []
  loop do
    keep_reading, *bits = input[@pos, 5]
    @pos += 5
    literal += bits
    break if keep_reading == "0"
  end
  literal.join.to_i(2)
end

def parse_operator(type)
  debug "parsing operator #{type}"
  terms = []
  case input[@pos]
  when "0" # total length in bits
    @pos += 1
    sub_packet_length = input[@pos, 15].join.to_i(2)
    debug "sub packet length is #{sub_packet_length} bits"
    @pos += 15
    sub_packet_pos = sub_packet_length + @pos
    while @pos < sub_packet_pos
      terms += parse(input, 1)
    end
    debug "finished reading #{sub_packet_length} bits"
  when "1" # number of sub-packets
    @pos += 1
    sub_packet_count = input[@pos, 11].join.to_i(2)
    debug "There are #{sub_packet_count} sub packets"
    @pos += 11
    sub_packet_count.times do
      terms += parse(input, 1)
    end
    debug "finished reading #{sub_packet_count} sub packets"
  end
  [type, terms]
end

@pos = 0
@versions = 0

def parse(input, limit = -1)
  terms = []
  while @pos < input.size && !input[@pos, input.size - @pos - 1].all? { |c| c == "0" }
    break if limit == 0
    version, type = parse_header
    @versions += version
    case type
    when 4 # literal value
      lit = parse_literal
      debug "value: " + lit.to_s
      terms << lit
    else # operator
      args = parse_operator(type)
      debug "terms: " + args.inspect
      terms << args
    end
    limit -= 1
  end
  terms
end

@debug = false

if __FILE__ == $0
  parse(input).tap { p @versions }
end
