points1 = [[0,0]]
points2 = [[0,0]]

A = File.read("aoc_2019_3.txt")
steps1, steps2 = A.split("\n").map {|a| a.split(",")}

def move(step)
  if step[0] == "R"
    [step[1..-1].to_i, 0]
  elsif step[0] == "L"
    [-step[1..-1].to_i, 0]
  elsif step[0] == "U"
    [0, step[1..-1].to_i]
  elsif step[0] == "D"  
    [0, -step[1..-1].to_i]
  end
end    

# 1

[steps1, steps2].each do |step_arr|
  arr = step_arr == steps1 ? points1 : points2
  step_arr.each do |step|
    point1, point2 = arr.last
    move = move(step)
    steps = move.map(&:abs).max
    steps.times do
      arr << [point1+=move[0]/steps, point2+=move[1]/steps]
    end  
  end    
end


p (points1 & points2).reject {|a| a == [0,0]}.map {|a,b| a.abs+b.abs}.min

# 2
points1 = [[0,0]]
points2 = [[0,0]]

hash1 = {}
hash2 = {}

total1 = 0
total2 = 0
[steps1, steps2].each do |step_arr|
  arr = step_arr == steps1 ? points1 : points2
  total = step_arr == steps1 ? total1 : total2
  hash = step_arr == steps1 ? hash1 : hash2
  step_arr.each do |step|
    point1, point2 = arr.last
    move = move(step)
    steps = move.map(&:abs).max
    steps.times do
      total += 1
      val = [point1+=move[0]/steps, point2+=move[1]/steps]
      arr << val
      hash[val] = total
    end  
  end    
end

p (points1 & points2).reject {|a| a == [0,0]}.map {|a| hash1[a].to_i + hash2[a].to_i}.reject {|a| a == 0}.compact.min


