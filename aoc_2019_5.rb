# 1

def run(arr,input)
  i = 0
  loop do
    opcode, modes = parameters(arr[i])
    if opcode == 1
      arr[arr[i+3]] = (modes[0].to_i == 0 ? arr[arr[i+1]] : arr[i+1]) + (modes[1].to_i == 0 ? arr[arr[i+2]] : arr[i+2])
      i += 4
    elsif opcode == 2
      arr[arr[i+3]] = (modes[0].to_i == 0 ? arr[arr[i+1]] : arr[i+1]) * (modes[1].to_i == 0 ? arr[arr[i+2]] : arr[i+2])
      i += 4
    elsif opcode == 3
      arr[arr[i+1]] = input  
      i += 2
    elsif opcode == 4
      puts arr[arr[i+1]]
      i += 2
    elsif opcode == 99
      return arr[0]
    end
  end  
end

def parameters(dig)
  opcode = dig.to_s.length == 1 ? dig : dig.to_s[-2..-1].to_i
  modes = dig.to_s[0..-3].split("").to_a.reverse
  [opcode, modes]
end  

A = File.read("aoc_2019_5.txt")

arr = A.split(",").map(&:to_i)
run(arr,1)

# 2

def run(arr,input)
  i = 0
  loop do
    opcode, modes = parameters(arr[i])
    if opcode == 1
      arr[arr[i+3]] = (modes[0].to_i == 0 ? arr[arr[i+1]] : arr[i+1]) + (modes[1].to_i == 0 ? arr[arr[i+2]] : arr[i+2])
      i += 4
    elsif opcode == 2
      arr[arr[i+3]] = (modes[0].to_i == 0 ? arr[arr[i+1]] : arr[i+1]) * (modes[1].to_i == 0 ? arr[arr[i+2]] : arr[i+2])
      i += 4
    elsif opcode == 3
      arr[arr[i+1]] = input  
      i += 2
    elsif opcode == 4
      modes[0].to_i == 0 ? p(arr[arr[i+1]]) : p(arr[i+1])
      i += 2
    elsif opcode == 5
      if modes[0].to_i == 0 ? arr[arr[i+1]] != 0 : arr[i+1] != 0
        arr[i] = arr[i+2] 
        i = arr[i]
      else
        i += 3
      end  
    elsif opcode == 6
      if modes[0].to_i == 0 ? arr[arr[i+1]] == 0 : arr[i+1] == 0
        arr[i] = arr[i+2] 
        i = arr[i]
      else
        i += 3 
      end  
    elsif opcode == 7
      val1 = modes[0].to_i == 0 ? arr[arr[i+1]] : arr[i+1]
      val2 = modes[1].to_i == 0 ? arr[arr[i+2]] : arr[i+2]
      if val1 < val2
        arr[arr[i+3]] = 1
      else
        arr[arr[i+3]] = 0
      end
      i += 4
    elsif opcode == 8
      val1 = modes[0].to_i == 0 ? arr[arr[i+1]] : arr[i+1]
      val2 = modes[1].to_i == 0 ? arr[arr[i+2]] : arr[i+2]
      if val1 == val2
        arr[arr[i+3]] = 1
      else
        arr[arr[i+3]] = 0
      end
      i += 4      
    elsif opcode == 99
      return arr[0]
    else
      i = arr[i]
    end   
  end  
end   

arr = A.split(",").map(&:to_i)
run(arr,5) 


