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

map = A.split("\n").map {|a| a.split("")}

near_dot = []
graph = []
limit = 27
i = 0
j = 0
while i < map.length 
  while j < map[i].length
    if map.fetch(i).fetch(j) == "."
      if map.fetch(i-1).fetch(j) == "."
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i-1}-#{j}-#{n}", 1]
        end  
      end  
      if ("A".."Z").to_a.include?(map.fetch(i-1).fetch(j).to_s)
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i-1}-#{j}-#{n}", 0]
        end  
        near_dot << [i-1,j] if ("A".."Z").to_a.include?(map.fetch(i-1).fetch(j).to_s)
      end  
      if map.fetch(i+1).fetch(j) == "." 
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i+1}-#{j}-#{n}", 1]
        end  
      end  
      if ("A".."Z").to_a.include?(map.fetch(i+1).fetch(j).to_s)
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i+1}-#{j}-#{n}", 0]
        end  
        near_dot << [i+1,j] if ("A".."Z").to_a.include?(map.fetch(i+1).fetch(j).to_s)
      end
      if map.fetch(i).fetch(j+1) == "."
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i}-#{j+1}-#{n}", 1]
        end  
      end  
      if ("A".."Z").to_a.include?(map.fetch(i).fetch(j+1).to_s)
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i}-#{j+1}-#{n}", 0]
        end  
        near_dot << [i,j+1] if ("A".."Z").to_a.include?(map.fetch(i).fetch(j+1).to_s)
      end  
      if map.fetch(i).fetch(j-1) == "."
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i}-#{j-1}-#{n}", 1]
        end  
      end
      if ("A".."Z").to_a.include?(map.fetch(i).fetch(j-1).to_s)
        limit.times do |n|
          graph << ["#{i}-#{j}-#{n}", "#{i}-#{j-1}-#{n}", 0]
        end 
        near_dot << [i,j-1] if ("A".."Z").to_a.include?(map.fetch(i).fetch(j-1).to_s)
      end       
    end
    j += 1
  end
  i += 1
  j = 0
end

letters_outer_hash = {}
letters_inner_hash = {}

start, target = nil
i = 0
j = 0
while i < map.length 
  while j < map[i].length
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i-1).fetch(j).to_s) && ((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_outer_hash[map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s] ||= []
      letters_outer_hash[map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s] << [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s) && ((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_outer_hash[map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s] ||= []
      letters_outer_hash[map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s] << [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i+1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i+1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j-1).to_s) && ((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_outer_hash[map.fetch(i).fetch(j-1).to_s + map.fetch(i).fetch(j).to_s] ||= []
      letters_outer_hash[map.fetch(i).fetch(j-1).to_s + map.fetch(i).fetch(j).to_s] << [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j-1).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j-1).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s) && ((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_outer_hash[map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s] ||= []
      letters_outer_hash[map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s] << [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j+1).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j+1).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end
    j += 1
  end
  i += 1
  j = 0
end 

i = 0
j = 0
while i < map.length 
  while j < map[i].length
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i-1).fetch(j).to_s) && !((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_inner_hash[map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s] ||= []
      letters_inner_hash[map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s] << [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i-1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i-1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s) && !((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_inner_hash[map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s] ||= []
      letters_inner_hash[map.fetch(i).fetch(j).to_s + map.fetch(i+1).fetch(j).to_s] << [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i+1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i+1,j]].select {|a| near_dot.include?(a)}.first if map.fetch(i+1).fetch(j).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j-1).to_s) && !((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_inner_hash[map.fetch(i).fetch(j-1).to_s + map.fetch(i).fetch(j).to_s] ||= []
      letters_inner_hash[map.fetch(i).fetch(j-1).to_s + map.fetch(i).fetch(j).to_s] << [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j-1).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i,j-1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j-1).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end  
    if ("AA".."ZZ").to_a.include?(map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s) && !((i < 3 || j <3) || (i > map.length-3 || j > map[i].length-3))
      letters_inner_hash[map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s] ||= []
      letters_inner_hash[map.fetch(i).fetch(j).to_s + map.fetch(i).fetch(j+1).to_s] << [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first
      start = [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j+1).to_s+map.fetch(i).fetch(j).to_s == "AA"
      target = [[i,j],[i,j+1]].select {|a| near_dot.include?(a)}.first if map.fetch(i).fetch(j+1).to_s+map.fetch(i).fetch(j).to_s == "ZZ"
    end
    j += 1
  end
  i += 1
  j = 0
end


filtered_outer_hash = {}
letters_outer_hash.each do |k,v|
  filtered_outer_hash[k] = v.uniq.reject {|z| !z || z.count == 0}.first
end

filtered_inner_hash = {}
letters_inner_hash.each do |k,v|
  filtered_inner_hash[k] = v.uniq.reject {|z| !z || z.count == 0}.first
end


filtered_outer_hash.each do |k,v|
  w = filtered_inner_hash[k]
  next unless w
  limit.times do |n|
    graph << ["#{v[0]}-#{v[1]}-#{n}", "#{w[0]}-#{w[1]}-#{n-1}", 1]
    graph << ["#{w[0]}-#{w[1]}-#{n-1}", "#{v[0]}-#{v[1]}-#{n}", 1]
  end  
end

filtered_inner_hash.each do |k,v|
  w = filtered_outer_hash[k]
  next unless w
  limit.times do |n|
    graph << ["#{v[0]}-#{v[1]}-#{n}", "#{w[0]}-#{w[1]}-#{n+1}", 1]
    graph << ["#{w[0]}-#{w[1]}-#{n+1}", "#{v[0]}-#{v[1]}-#{n}", 1]
  end  
end

p graph.length
g = Graph.new(graph)
  
p g.shortest_path("#{start[0]}-#{start[1]}-0", "#{target[0]}-#{target[1]}-0")[1]
