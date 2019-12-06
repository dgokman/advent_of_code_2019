# 1

require 'set'
A = File.read("aoc_2019_6.txt")
a = A.split("\n").map {|a| a.split(")")}

hash = {}
val = 0
loop do
  a.each do |b,c|
    hash[c] ||= Set.new
    hash[c] << b
    indirects = Set.new
    hash[c].each do |v|
      indirects << hash[v]
    end
    hash[c] += indirects
    hash[c].flatten!
    hash[c].reject! {|a| a.nil?}
  end
  break if hash.values.map {|a| a.to_a}.flatten.count == val
  val = hash.values.map {|a| a.to_a}.flatten.count
end  

p val

# 2

class Graph

  def add_edge(node_a, node_b)
    node_a.adjacents << node_b
    node_b.adjacents << node_a
  end
end

class BreadthFirstSearch
  def initialize(graph, source_node)
    @graph = graph
    @node = source_node
    @visited = []
    @edge_to = {}

    bfs(source_node)
  end

  def shortest_path_to(node)
    return unless has_path_to?(node)
    path = []

    while(node != @node) do
      path.unshift(node) # unshift adds the node to the beginning of the array
      node = @edge_to[node]
    end

    path.unshift(@node)
  end

  private
  def bfs(node)

    queue = []
    queue << node
    @visited << node

    while queue.any?
      current_node = queue.shift # remove first element
      current_node.adjacents.each do |adjacent_node|
        next if @visited.include?(adjacent_node)
        queue << adjacent_node
        @visited << adjacent_node
        @edge_to[adjacent_node] = current_node
      end
    end
  end

  def has_path_to?(node)
    @visited.include?(node)
  end
end

class Node
  attr_accessor :name, :adjacents

  def initialize(name)
    @adjacents = Set.new
    @name = name
  end

  def to_s
    @name
  end
end

nodes_hash = {}
a.each do |b,c|
  nodes_hash[b] = Node.new(b)
  nodes_hash[c] = Node.new(c)
end  
graph = Graph.new
a.each do |b,c|
  graph.add_edge(nodes_hash[c],nodes_hash[b])
end 

p BreadthFirstSearch.new(graph, nodes_hash["YOU"]).shortest_path_to(nodes_hash["SAN"]).length-3


