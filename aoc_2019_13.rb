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

def time_difference(time_a, time_b)
  difference = time_b - time_a

  if difference > 0
    difference
  else
    24 * 3600 + difference 
  end
end

@sequence = []

def run(arr,input1)
  i = 0
  output = 0
  r = 0
  start = Time.now
  loop do
    running = Time.now
    if time_difference(start, running) > 1
      return "restart"
    end  
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
      if modes[0].to_i == 0
        arr[arr[i+1]] = input1 
      elsif modes[0].to_i == 1
        arr[i+1] = input1
      else  
        arr[arr[i+1]+r] = input1
      end    
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1, r)
      @sequence << output
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
      return arr
    end  
  end  
end

def parameters(dig)
  opcode = dig.to_s.length == 1 ? dig : dig.to_s[-2..-1].to_i
  modes = dig.to_s[0..-3].split("").to_a.reverse
  [opcode, modes]
end

A = File.read("aoc_2019_13.txt")
arr = A.split(",").map(&:to_i)

# 1 
run(arr,nil) 
p @sequence.each_slice(3).map(&:last).count(2)

# 2

finished = false
score = 0

catch :value do
  loop do
    arr = A.split(",").map(&:to_i)
    arr[0] = 2
    loop do
      jstick = [-1,0,1].sample
      arr = run(arr,jstick)
      if arr == "restart"
        break
      end  
      game = Array.new(20){Array.new(45)}
      count = 0
      @sequence.each_slice(3) do |x,y,id|
        if x == -1 && y == 0
          if game.flatten.count("B") == 0
            score = id
            throw :value
          end  
        else 
          case id
          when 0
            game[y][x] = "."
          when 1 
            game[y][x] = "#"
          when 2
            game[y][x] = "B"
          when 3
            game[y][x] = "P"
          when 4
            game[y][x] = "o"
          end
        end  
      end
      @sequence = []
    end
  end  
end

p score
