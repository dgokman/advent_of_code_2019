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

def run(arr,input1,input2)
  i = 0
  output = 0
  r = 0
  input_one_done = false
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
      input = input_one_done ? input2 : input1
      if modes[0].to_i == 0
        arr[arr[i+1]] = input 
      elsif modes[0].to_i == 1
        arr[i+1] = input
      else  
        arr[arr[i+1]+r] = input
      end  
      input_one_done = true  
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1, r)
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

A = File.read("aoc_2019_19.txt")
arr = A.split(",").map(&:to_i)
clone_arr = arr.clone

# 1 
count = 0
for i in 0..49
  for j in 0..49
    if run(clone_arr,i,j) == 1
      count += 1
    end
    clone_arr = arr.clone
  end
end

p count 

# 2
L = 1500
arr = A.split(",").map(&:to_i)
clone_arr = arr.clone
new_arr = Array.new(L){Array.new(L)}

i = 0
j = 0
while i < L
  one = false
  count = 0
  while j < L
    run = run(clone_arr,i,j)
    if run == 1
      count += 1
      one = true
    end
    if one && run == 0
      clone_arr = arr.clone
      break
    end    
    new_arr[i][j] = run
    clone_arr = arr.clone
    j += 1
  end
  j = 0
  i += 1
end

lim = 99
i = 0
j = 0
loop do
  loop do
    if new_arr[i][j] == 1
      flat = new_arr[i][j..j+lim]
      if flat.all? {|a| a == 1}
        box = new_arr[i..i+lim].map {|a| a[j..j+lim]}
        if box.flatten.all? {|a| a == 1}
          puts i*10000+j
          raise
        end
      else
        break
      end    
    end
    break if !(new_arr[i][j])
    j += 1 
  end
  j = 0
  i += 1
end      


