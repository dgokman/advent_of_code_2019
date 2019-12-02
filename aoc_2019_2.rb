A = File.read("aoc_2019_2.txt")

arr = A.split(",").map(&:to_i)

def run(a,b,arr)
  arr[1] = a
  arr[2] = b
  i = 0
  loop do
    if arr[i] == 1
      arr[arr[i+3]] = arr[arr[i+1]] + arr[arr[i+2]]
      i += 4
    elsif arr[i] == 2
      arr[arr[i+3]] = arr[arr[i+1]] * arr[arr[i+2]]
      i += 4
    elsif arr[i] == 99
      return arr[0]
    end
  end     
end

# 1

p run(12,2,arr)

# 2

for a in 0..99
  for b in 0..99
    arr = A.split(",").map(&:to_i)
    if run(a,b,arr) == 19690720
      puts 100*a+b
    end
  end
end    