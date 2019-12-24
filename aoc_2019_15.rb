require 'set'

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

def write_value(mode, arr, i, relative_base)
  if mode == 0
    arr[i]
  elsif mode == 1
    i
  else
    arr[i]+relative_base
  end
end     

def value(mode, arr, i, relative_base)
  if mode == 0
    arr[arr[i]]
  elsif mode == 1
    arr[i]
  else
    arr[arr[i]+relative_base]
  end  
end    

def run(arr,input1,i)
  i = 0
  output = 0
  r = 0
  loop do
    opcode, modes = parameters(arr[i])
    if opcode == 1
      a = write_value(modes[2].to_i, arr, i+3, r).to_i
      arr[a] = value(modes[0].to_i, arr, i+1, r).to_i + value(modes[1].to_i, arr, i+2, r).to_i
      i += 4
    elsif opcode == 2
      a = write_value(modes[2].to_i, arr, i+3, r).to_i
      arr[a] = value(modes[0].to_i, arr, i+1, r).to_i * value(modes[1].to_i, arr, i+2, r).to_i
      i += 4
    elsif opcode == 3
      if modes[0].to_i == 0
        arr[arr[i+1]] = input1 
      elsif modes[0].to_i == 1
        arr[i+1] = input1
      else  
        arr[arr[i+1]+r] = input1
      end    
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1, r)
      return [arr, output, i+2]
      i += 2
    elsif opcode == 5
      if value(modes[0].to_i, arr, i+1, r) != 0
        i = value(modes[1].to_i, arr, i+2, r)
      else
        i += 3
      end  
    elsif opcode == 6
      if value(modes[0].to_i, arr, i+1, r) == 0
        i = value(modes[1].to_i, arr, i+2, r)
      else
        i += 3 
      end 
    elsif opcode == 7
      a = write_value(modes[2].to_i, arr, i+3, r).to_i
      val1 = value(modes[0].to_i, arr, i+1, r)
      val2 = value(modes[1].to_i, arr, i+2, r)
      if val1 < val2
        arr[a] = 1
      else
        arr[a] = 0
      end
      i += 4
    elsif opcode == 8
      a = write_value(modes[2].to_i, arr, i+3, r).to_i
      val1 = value(modes[0].to_i, arr, i+1, r)
      val2 = value(modes[1].to_i, arr, i+2, r)
      if val1 == val2
        arr[a] = 1
      else
        arr[a] = 0
      end
      i += 4  
    elsif opcode == 9
      r += value(modes[0].to_i, arr, i+1, r)
      i += 2
    elsif opcode == 99
      return output
    end  
  end  
end

def parameters(dig)
  opcode = dig.to_s.length == 1 ? dig : dig.to_s[-2..-1].to_i
  modes = dig.to_s[0..-3].split("").to_a.reverse
  [opcode, modes]
end

A = File.read("aoc_2019_15.txt")
arr = A.split(",").map(&:to_i)

board = Array.new(60){Array.new(60)}
orig_pos = [30,30]
pos = orig_pos.clone
board[pos[0]][pos[1]] = "D"
idx = 0
input = rand(1..4)
target = nil
found = false
count = 0
loop do
  arr, output, idx = run(arr,input,idx)
  new_pos = nil
  case input
  when 1
    new_pos = [pos[0]-1, pos[1]]
  when 2
    new_pos = [pos[0]+1, pos[1]]
  when 3
    new_pos = [pos[0], pos[1]-1]
  when 4
    new_pos = [pos[0], pos[1]+1]
  end
  if output == 2
    target = new_pos
    pos = new_pos
    board[new_pos[0]][new_pos[1]] = "O"
    found = true
  elsif output == 1
    pos = new_pos
    if board[new_pos[0]][new_pos[1]] != "D"
      board[new_pos[0]][new_pos[1]] = "."
    end  
  else
    board[new_pos[0]][new_pos[1]] = "#"
  end
  valid_moves = []
  if board[pos[0]-1][pos[1]] != "#"
    valid_moves << 1
  end
  if board[pos[0]+1][pos[1]] != "#"  
    valid_moves << 2
  end
  if board[pos[0]][pos[1]-1] != "#"
    valid_moves << 3
  end
  if board[pos[0]][pos[1]+1] != "#"  
    valid_moves << 4
  end  
  if found
    count += 1
  end
  if count == 500000 # draw out the map
    break
  end    

  input = valid_moves.sample
end

nodes_hash = {}
for i in 0..board.length-1
  for j in 0..board.length-1
    nodes_hash[[i,j]] = Node.new([i,j])
  end  
end  

graph = Graph.new

for i in 1..board.length-2
  for j in 1..board.length-2
    if board[i][j] && board[i][j] != "#"
      if board[i-1][j] && board[i-1][j] != "#"
        graph.add_edge(nodes_hash[[i,j]],nodes_hash[[i-1,j]])
      end
      if board[i+1][j] && board[i+1][j] != "#"
        graph.add_edge(nodes_hash[[i,j]],nodes_hash[[i+1,j]])
      end
      if board[i][j-1] && board[i][j-1] != "#"
        graph.add_edge(nodes_hash[[i,j]],nodes_hash[[i,j-1]])
      end
      if board[i][j+1] && board[i][j+1] != "#"
        graph.add_edge(nodes_hash[[i,j]],nodes_hash[[i,j+1]])
      end
    end
  end
end

# 1
path = BreadthFirstSearch.new(graph, nodes_hash[orig_pos]).shortest_path_to(nodes_hash[target])

p path.length-1

# 2
minutes = 0
oxygens = Set.new
oxygen_count = 0
loop do
  for i in 1..board.length-2
    for j in 1..board.length-2
      if board[i][j] == "O"
        oxygens << [i,j]
      end
    end
  end      
  oxygens.each do |target|
    i, j = target
    i += 1
    board[i][j] = "O" if board[i][j] && board[i][j] != "#" 
      
    i, j = target
    i -= 1
    board[i][j] = "O" if board[i][j] && board[i][j] != "#" 
     
    i, j = target
    j += 1
    board[i][j] = "O" if board[i][j] && board[i][j] != "#" 
      
    i, j = target
    j -= 1
    board[i][j] = "O" if board[i][j] && board[i][j] != "#" 
  end
  break if oxygen_count == board.flatten.count("O")
  oxygen_count = board.flatten.count("O")
  minutes += 1
end    

p minutes

