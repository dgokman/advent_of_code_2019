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

@string = ""

def run(arr, input1="")
  i = 0
  output = 0
  r = 0
  input_idx = 0
  inputs = input1.split("").map {|a| a.ord}

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
      input1 = inputs[input_idx]
      if modes[0].to_i == 0

        arr[arr[i+1]] = input1
      elsif modes[0].to_i == 1
        arr[i+1] = input1
      else  
        arr[arr[i+1]+r] = input1
      end   
      input_idx += 1 
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1, r)
      if output.between?(0,127)
        print "#{output.chr}"
      else
        p output
        return
      end    
      @string << output
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
      return unless val1 && val2
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

A = File.read("aoc_2019_17.txt")
arr = A.split(",").map(&:to_i)

# 2
require 'set'

arr[0] = 2  
run(arr)  

field = @string.split("\n").map {|x| x.split("")}
start = nil
scaffolds = []
i = 0
j = 0
while i < field.length
  while j < field[i].length
    if field[i][j] == "^"
      start = [i,j]
    elsif field[i][j] == "#" 
      scaffolds << [i,j]
    end  
    j += 1
  end
  i += 1
  j = 0
end

scaffolds == scaffolds.sort

i, j = start

dir = "E"
relative_dir = "R"
dir_string = ""
count = 0
visited = Set.new

require 'pry'
loop do
  adjacent_acres = [
    field.fetch(i-1).fetch(j), 
    field.fetch(i+1).fetch(j), 
    field.fetch(i).fetch(j-1), 
    field.fetch(i).fetch(j+1)]
  if [adjacent_acres[0..1].count("#"), adjacent_acres[2..3].count("#")] == [1,1]

    dir_string << "#{relative_dir},#{count},"
    
    count = 1
    if dir == "E"
      if adjacent_acres[0..1].index("#") == 0
        dir = "N"
        relative_dir = "L"
        i -= 1
      else
        dir = "S"
        relative_dir = "R"
        i += 1
      end
    elsif dir == "W"
      if adjacent_acres[0..1].index("#") == 0
        dir = "N"
        relative_dir = "R"
        i -= 1
      else
        dir = "S"
        relative_dir = "L"
        i += 1
      end
    elsif dir == "N"
      if adjacent_acres[2..3].index("#") == 0
        dir = "W"
        relative_dir = "L"
        j -= 1
      else
        dir = "E"
        relative_dir = "R"
        j += 1
      end 
    else
      if adjacent_acres[2..3].index("#") == 0
        dir = "W"
        relative_dir = "R"
        j -= 1
      else
        dir = "E"
        relative_dir = "L"
        j += 1
      end
    end
  else
    count += 1
    case dir
    when "E"
      j += 1
    when "W"
      j -= 1
    when "N"
      i -= 1
    when "S"
      i += 1
    end
  end
  visited << [i,j]
  if visited.sort == scaffolds.sort
    dir_string << "#{relative_dir}#{count},"
    break
  end  
end  

# manually found patterns from dir_string
arr = A.split(",").map(&:to_i)

arr[0] = 2  

a = "R,6,L,10,R,8,R,8\n"
b = "R,12,L,10,R,6,L,10\n"
c = "R,12,L,8,L,10\n"

functions = "A,C,A,B,C,B,A,C,A,B\n"

input = functions + a + b + c + "y\n"
run(arr, input)

