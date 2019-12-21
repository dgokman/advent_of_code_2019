def value(mode, arr, i)
  if mode == 0
    arr[arr[i]]
  else
    arr[i]    
  end
end    

def run(arr,input1,input2,idx,looped)
  i = idx
  output = nil
  input_one_done = false
  input_two_done = false
  loop do
    opcode, modes = parameters(arr[i])
    if opcode == 1
      arr[arr[i+3]] = value(modes[0].to_i, arr, i+1) + value(modes[1].to_i, arr, i+2)
      i += 4
    elsif opcode == 2
      arr[arr[i+3]] = value(modes[0].to_i, arr, i+1) * value(modes[1].to_i, arr, i+2)
      i += 4
    elsif opcode == 3
      if !input_one_done && !looped
        arr[arr[i+1]] = input1 
        input_one_done = true
      else
        arr[arr[i+1]] = input2
      end  
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1)
      return [output,i+2]
      i += 2
    elsif opcode == 5
      if value(modes[0].to_i, arr, i+1) != 0
        i = value(modes[1].to_i, arr, i+2)
      else
        i += 3
      end  
    elsif opcode == 6
      if value(modes[0].to_i, arr, i+1) == 0
        i = value(modes[1].to_i, arr, i+2)
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
      return [output, nil]
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
looped = false
input2 = 0
output = 0
[5,6,7,8,9].permutation(5).each do |inputs|
  looped = false
  input2 = 0
  output = 0
  arr0 = A.split(",").map(&:to_i)
  arr1 = A.split(",").map(&:to_i)
  arr2 = A.split(",").map(&:to_i)
  arr3 = A.split(",").map(&:to_i)
  arr4 = A.split(",").map(&:to_i)
  idxs = [0,0,0,0,0]
  loop do
    new_inputs = inputs.clone
    inputs.each_with_index do |input1,idx|
      next unless input1
      input2, i = run(eval("arr#{idx}"),input1,input2,idxs[idx],looped)
      if i.nil?
        new_inputs[idx] = nil
      else  
        idxs[idx] = i
      end
    end
    output = input2 if input2
    looped = true
    inputs = new_inputs.clone
    break if !inputs.any?
  end  
  if output > max
    max = output
  end
end

p max 

