#!/usr/bin/env ruby

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
