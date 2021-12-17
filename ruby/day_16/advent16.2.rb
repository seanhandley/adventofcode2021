#!/usr/bin/env ruby

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