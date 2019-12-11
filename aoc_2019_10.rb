A = File.read("aoc_2019_10.txt")
require 'set'

# 1
hash = {}

arr = A.split("\n").map {|x| x.split("")}
for x in 0..arr[0].length-1
  for y in 0..arr.length-1
    if arr[y][x] == "#"
      hash[[y,x]] = 1
    end
  end
end

set = Set.new
for x in 0..arr[0].length-1    
  for y in 0..arr.length-1
    next if arr[y][x] == "."

    for a in 0..arr[0].length-1
      for b in 0..arr.length-1
        next if arr[b][a] == "."
        next if x == a && y == b
        if a-x == 0 && b > y
          set << [[x,y],-Float::INFINITY,"N"]
        elsif a-x == 0
          set << [[x,y],-Float::INFINITY,"S"]
        elsif b-y == 0 && a > x
          set << [[x,y],0,"N"]
        elsif b-y == 0  
          set << [[x,y],0,"S"]
        elsif b > y
          set << [[x,y],(y-b)/(x-a).to_r,"N"]
        else
          set << [[x,y],(y-b)/(x-a).to_r,"S"] 
        end
      end
    end
  end
end

hash2 = Hash.new(0)
set.each do |k|
  hash2[k.first] += 1
end

coordinates, total = hash2.sort_by {|k,v| -v}.first
p total

# 2


set = Set.new
x, y = coordinates

for a in 0..arr[0].length-1
  for b in 0..arr.length-1
    next if arr[b][a] == "."
    next if x == a && y == b
    if a-x == 0 && b > y
      set << [[a,b],-Float::INFINITY,"N"]
    elsif a-x == 0
      set << [[a,b],-Float::INFINITY,"S"]
    elsif b-y == 0 && a > x
      set << [[a,b],0,"N"]
    elsif b-y == 0  
      set << [[a,b],0,"S"]
    elsif b > y
      set << [[a,b],(y-b)/(x-a).to_r,"N"]
    else
      set << [[a,b],(y-b)/(x-a).to_r,"S"] 
    end
  end
end

south_negatives = set.select {|(a,b),slope,dir| dir == "S" && slope < 0 }.sort_by {|(a,b),slope,dir| slope}
north_positives = set.select {|(a,b),slope,dir| dir == "N" && slope >= 0 }.sort_by {|(a,b),slope,dir| slope}
north_negatives = set.select {|(a,b),slope,dir| dir == "N" && slope < 0 }.sort_by {|(a,b),slope,dir| slope}
south_positives = set.select {|(a,b),slope,dir| dir == "S" && slope >= 0 }.sort_by {|(a,b),slope,dir| slope}

targets = Set.new

slope = nil
i = 0

[south_negatives, north_positives, north_negatives, south_positives].each do |arr|
  while i < arr.length
    if slope != arr[i][1] 
      if arr[i][1] == 0
        valid = arr.select {|_,s,_| s == arr[i][1]}.sort_by {|(a,b),_,_| a-x}.first
      else 
        valid = arr.select {|_,s,_| s == arr[i][1]}.sort_by {|(a,b),_,_| b-y}.first 
      end  
      targets << valid if valid
    end  
    slope = arr[i][1]
    i += 1
  end
  i = 0
end  

p targets.to_a[199][0][0]*100+targets.to_a[199][0][1]

