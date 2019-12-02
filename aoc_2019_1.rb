A = File.read("aoc_2019_1.txt")

def find_fuel(mass)
  mass/3-2
end

def find_total_fuel(mass)
  total = 0
  until find_fuel(mass) < 0
    mass = find_fuel(mass)
    total += mass
  end
  total
end    

# 1 
p A.split("\n").map {|a| find_fuel(a.to_i)}.inject(:+)

# 2
p A.split("\n").map {|a| find_total_fuel(a.to_i)}.inject(:+)