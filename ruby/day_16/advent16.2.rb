#!/usr/bin/env ruby

# --- Part Two ---
# Now that you have the structure of your transmission decoded, you can calculate the value of the expression it represents.
#
# Literal values (type ID 4) represent a single number as described above. The remaining type IDs are more interesting:
#
# Packets with type ID 0 are sum packets - their value is the sum of the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
# Packets with type ID 1 are product packets - their value is the result of multiplying together the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
# Packets with type ID 2 are minimum packets - their value is the minimum of the values of their sub-packets.
# Packets with type ID 3 are maximum packets - their value is the maximum of the values of their sub-packets.
# Packets with type ID 5 are greater than packets - their value is 1 if the value of the first sub-packet is greater than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
# Packets with type ID 6 are less than packets - their value is 1 if the value of the first sub-packet is less than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
# Packets with type ID 7 are equal to packets - their value is 1 if the value of the first sub-packet is equal to the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
#
# Using these rules, you can now work out the value of the outermost packet in your BITS transmission.
#
# For example:
#
# C200B40A82 finds the sum of 1 and 2, resulting in the value 3.
# 04005AC33890 finds the product of 6 and 9, resulting in the value 54.
# 880086C3E88112 finds the minimum of 7, 8, and 9, resulting in the value 7.
# CE00C43D881120 finds the maximum of 7, 8, and 9, resulting in the value 9.
# D8005AC2A8F0 produces 1, because 5 is less than 15.
# F600BC2D8F produces 0, because 5 is not greater than 15.
# 9C005AC2F8F0 produces 0, because 5 is not equal to 15.
# 9C0141080250320F1802104A08 produces 1, because 1 + 3 = 2 * 2.
#
# What do you get if you evaluate the expression represented by your hexadecimal-encoded BITS transmission?

require_relative "./advent16.1"

def print_terms(terms)
  terms.each(&method(:debug))
end

def evaluate(terms)
  return terms if terms.is_a?(Array) && terms.all? { |e| e.is_a?(Integer) }
  terms.map do |term|
    print_terms(terms)
    if term.is_a?(Array)
      case term.first
      when 0
        evaluate(term.last).sum
      when 1
        evaluate(term.last).reduce(:*)
      when 2
        evaluate(term.last).min
      when 3
        evaluate(term.last).max
      when 5
        evaluate(term.last).reduce(:>) ? 1 : 0
      when 6
        evaluate(term.last).reduce(:<) ? 1 : 0
      when 7
        evaluate(term.last).reduce(:==) ? 1 : 0
      end
    else
      term
    end
  end
end

if __FILE__ == $0
  i = parse(input)
  debug "*******"
  p evaluate(i).first
end
