def value(mode, arr, i)
  if mode == 0
    arr[arr[i]]
  else
    arr[i]    
  end
end    

def run(arr,input1,input2)
  i = 0
  output = 0
  input_one_done = false
  loop do
    opcode, modes = parameters(arr[i])
    if opcode == 1
      arr[arr[i+3]] = value(modes[0].to_i, arr, i+1) + value(modes[1].to_i, arr, i+2)
      i += 4
    elsif opcode == 2
      arr[arr[i+3]] = value(modes[0].to_i, arr, i+1) * value(modes[1].to_i, arr, i+2)
      i += 4
    elsif opcode == 3
      if !input_one_done
        arr[arr[i+1]] = input1 
        input_one_done = true
      else
        arr[arr[i+1]] = input2
      end
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1)
      i += 2
    elsif opcode == 5
      if value(modes[0].to_i, arr, i+1) != 0
        arr[i] = arr[i+2] 
        i = arr[i]
      else
        i += 3
      end  
    elsif opcode == 6
      if value(modes[0].to_i, arr, i+1) == 0
        arr[i] = arr[i+2] 
        i = arr[i]
      else
        i += 3 
      end  
    elsif opcode == 7
      val1 = value(modes[0].to_i, arr, i+1)
      val2 = value(modes[1].to_i, arr, i+2)
      if val1 < val2
        arr[arr[i+3]] = 1
      else
        arr[arr[i+3]] = 0
      end
      i += 4
    elsif opcode == 8
      val1 = value(modes[0].to_i, arr, i+1)
      val2 = value(modes[1].to_i, arr, i+2)
      if val1 == val2
        arr[arr[i+3]] = 1
      else
        arr[arr[i+3]] = 0
      end
      i += 4      
    elsif opcode == 99
      return output
    else
      i = arr[i]
    end   
  end  
end

def parameters(dig)
  opcode = dig.to_s.length == 1 ? dig : dig.to_s[-2..-1].to_i
  modes = dig.to_s[0..-3].split("").to_a.reverse
  [opcode, modes]
end

A = File.read("aoc_2019_7.txt")

arr = A.split(",").map(&:to_i)

max = 0
(0..4).to_a.permutation(5).each do |inputs|
  input2 = 0
  inputs.each do |input1|
    input2 = run(arr,input1,input2)
    arr = A.split(",").map(&:to_i) 
  end
  if input2 > max
    max = input2
  end
end

p max 

