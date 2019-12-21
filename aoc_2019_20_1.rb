A = File.read("aoc_2019_20.txt")

class NilClass
  def method_missing(*args); nil; end
end

class Array
  def fetch(index)
    if index < 0
      return nil
    end
    self[index]
  end
end

# taken from https://github.com/brianstorti/ruby-graph-algorithms/tree/master/breadth_first_search
class Graph
  Vertex = Struct.new(:name, :neighbours, :dist, :prev)

  def initialize(graph)
    @vertices = Hash.new{|h,k| h[k]=Vertex.new(k,[],Float::INFINITY)}
    @hash = {}
    graph.each do |v1,v2,dist|
      @hash[[v1,v2]] = dist
      @vertices[v1].neighbours << v2
      @vertices[v2].neighbours << v1
    end
    @dijkstra_source = nil
  end

  def dijkstra(source)
    return  if @dijkstra_source == source
    q = @vertices.values
    q.each do |v|
      v.dist = Float::INFINITY
      v.prev = nil
    end
    @vertices[source].dist = 0
    until q.empty?
      u = q.min_by {|vertex| vertex.dist}
      break if u.dist == Float::INFINITY
      q.delete(u)
      u.neighbours.each do |v|
        vv = @vertices[v]
        if q.include?(vv)
          alt = u.dist + (@hash[[u.name, v]] || 0)
          if alt < vv.dist
            vv.dist = alt
            vv.prev = u.name
          end
        end
      end
    end
    @dijkstra_source = source
  end

  def shortest_path(source, target)
    dijkstra(source)
    path = []
    u = target
    while u
      path.unshift(u)
      u = @vertices[u].prev
    end
    return path, @vertices[target].dist
  end
end

map = A.split("\n").map {|a| a.split("")}#[1..-1]

letters_hash = {}
near_dot = []
graph = []
i = 0
j = 0
while i < map.length 
  while j < map[i].length
    if map.fetch(i).fetch(j) == "."
      if map.fetch(i-1).fetch(j) == "."
        graph << ["#{i}-#{j}", "#{i-1}-#{j}", 1]
      end  
      if ("A".."Z").to_a.include?(map.fetch(i-1).fetch(j).to_s)
        graph << ["#{i}-#{j}", "#{i-1}-#{j}", 0]
        near_dot << [i-1,j] if ("A".."Z").to_a.include?(map.fetch(i-1).fetch(j).to_s)
      end  
      if map.fetch(i+1).fetch(j) == "." 
        graph << ["#{i}-#{j}", "#{i+1}-#{j}", 1]
      end  
      if ("A".."Z").to_a.include?(map.fetch(i+1).fetch(j).to_s)
        graph << ["#{i}-#{j}", "#{i+1}-#{j}", 0]
        near_dot << [i+1,j] if ("A".."Z").to_a.include?(map.fetch(i+1).fetch(j).to_s)
      end
      if map.fetch(i).fetch(j+1) == "."
        graph << ["#{i}-#{j}", "#{i}-#{j+1}", 1]
      end  
      if ("A".."Z").to_a.include?(map.fetch(i).fetch(j+1).to_s)
        graph << ["#{i}-#{j}", "#{i}-#{j+1}", 0]
        near_dot << [i,j+1] if ("A".."Z").to_a.include?(map.fetch(i).fetch(j+1).to_s)
      end  
      if map.fetch(i).fetch(j-1) == "."
        graph << ["#{i}-#{j}", "#{i}-#{j-1}", 1]
      end
      if ("A".."Z").to_a.include?(map.fetch(i).fetch(j-1).to_s)
        graph << ["#{i}-#{j}", "#{i}-#{j-1}", 0]
        near_dot << [i,j-1] if ("A".."Z").to_a.include?(map.fetch(i).fetch(j-1).to_s)
      end       
    end
    j += 1
  end
  i += 1
  j = 0
end

start, target = nil
i = 0
j = 0
while i < map.length 
  while j < map[i].length
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i-1).fetch(j).to_s)
      letters_hash[map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s] ||= []
      letters_hash[map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s] << [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s) 
      letters_hash[map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s] ||= []
      letters_hash[map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s] << [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i+1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i+1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j-1).to_s) 
      letters_hash[map.fetch(i).fetch(j-1).to_s + map.fetch(i).fetch(j).to_s] ||= []
      letters_hash[map.fetch(i).fetch(j-1).to_s + map.fetch(i).fetch(j).to_s] << [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j-1).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j-1).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s)
      letters_hash[map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s] ||= []
      letters_hash[map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s] << [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j+1).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j+1).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end
    j += 1
  end
  i += 1
  j = 0
end 

filtered_hash = {}
letters_hash.each do |k,v|
  filtered_hash[k] = v.uniq.reject {|z| !z || z.count == 0}
end

filtered_hash.each do |k,v|
  v.combination(2).each do |a,b|
    
    graph << ["#{a[0]}-#{a[1]}", "#{b[0]}-#{b[1]}", 1]
    graph << ["#{b[0]}-#{b[1]}", "#{a[0]}-#{a[1]}", 1]
  end
end

g = Graph.new(graph)
  
p g.shortest_path("#{start[0]}-#{start[1]}", "#{target[0]}-#{target[1]}")[1]
