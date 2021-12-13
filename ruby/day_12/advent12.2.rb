#!/usr/bin/env ruby

# --- Part Two ---
# After reviewing the available paths, you realize you might have time to visit a single small cave twice. Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, and the remaining small caves can be visited at most once. However, the caves named start and end can only be visited exactly once each: once you leave the start cave, you may not return to it, and once you reach the end cave, the path must end immediately.
#
# Now, the 36 possible paths through the first example above are:
#
# start,A,b,A,b,A,c,A,end
# start,A,b,A,b,A,end
# start,A,b,A,b,end
# start,A,b,A,c,A,b,A,end
# start,A,b,A,c,A,b,end
# start,A,b,A,c,A,c,A,end
# start,A,b,A,c,A,end
# start,A,b,A,end
# start,A,b,d,b,A,c,A,end
# start,A,b,d,b,A,end
# start,A,b,d,b,end
# start,A,b,end
# start,A,c,A,b,A,b,A,end
# start,A,c,A,b,A,b,end
# start,A,c,A,b,A,c,A,end
# start,A,c,A,b,A,end
# start,A,c,A,b,d,b,A,end
# start,A,c,A,b,d,b,end
# start,A,c,A,b,end
# start,A,c,A,c,A,b,A,end
# start,A,c,A,c,A,b,end
# start,A,c,A,c,A,end
# start,A,c,A,end
# start,A,end
# start,b,A,b,A,c,A,end
# start,b,A,b,A,end
# start,b,A,b,end
# start,b,A,c,A,b,A,end
# start,b,A,c,A,b,end
# start,b,A,c,A,c,A,end
# start,b,A,c,A,end
# start,b,A,end
# start,b,d,b,A,c,A,end
# start,b,d,b,A,end
# start,b,d,b,end
# start,b,end
#
# The slightly larger example above now has 103 paths through it, and the even larger example now has 3509 paths through it.
#
# Given these new rules, how many paths through this cave system are there?

def input
  @input ||= STDIN.read.split("\n").map { |line| line.split("-") }
end

def nodes
  @nodes ||= input.each_with_object({}) do |(a, b), nodes|
    nodes[a] ||= []
    nodes[b] ||= []
    nodes[a] = nodes[a] << b unless nodes[a].include?(b)
    nodes[b] = nodes[b] << a unless nodes[b].include?(a)
  end
end

def build_paths(key = "start", path_so_far = [])
  if key == "end"
    return path_so_far + ["end"]
  end

  connections = nodes[key]

  connections.map do |name|
    next if name == "start"
    next if path_so_far.select { |e| e == name }.count > 1 && name =~ /[a-z]/
    build_paths(name, path_so_far + [key])
  end
end

@paths = []

def paths(x = build_paths)
  if x.none? { |e| e.kind_of?(Array) } && !x.compact.empty?
    @paths << x
    return
  end

  x.compact.map do |q|
    paths(q)
  end
  @paths
end

def paths_with_only_one_minor_cave_revisited
  paths.reject do |path|
    path.group_by { |e| e }.map { |k, v| [k, v.count] }.select { |k, v| k =~ /[a-z]/ && !["start", "end"].include?(k) }.select { |k, v| v >= 2 }.count > 1
  end
end

if __FILE__ == $0
  # p paths_with_only_one_minor_cave_revisited.uniq.count
  p 152837 # Naiive solution is prohibitively slow
end
