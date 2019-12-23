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

@pos = [0,0]
@hash = {@pos => 0}
@dir = "U"
@sequence = []
@count_hash = {}

def run_paint(paint, rot)
  if paint == 1
    if @hash[@pos].to_i == 0
      @count_hash[@pos] = 1
    end  
    @hash[@pos] = 1
  else
    if @hash[@pos].to_i == 1
      @count_hash[@pos] = 1
    end  
    @hash[@pos] = 0
  end  
  if rot == 1
    case @dir
    when "U"
      @dir = "L" 
    when "L"
      @dir = "D"
    when "D"
      @dir = "R"
    when "R"
      @dir = "U"
    end
  else
    case @dir
    when "U"
      @dir = "R" 
    when "L"
      @dir = "U"
    when "D"
      @dir = "L"
    when "R"
      @dir = "D"
    end
  end
  case @dir
  when "U"
    @pos = [@pos[0]-1, @pos[1]] 
  when "L"
    @pos = [@pos[0], @pos[1]-1] 
  when "D"
    @pos = [@pos[0]+1, @pos[1]] 
  when "R"
    @pos = [@pos[0], @pos[1]+1] 
  end 
end

def run(arr)
  i = 0
  output = 0
  r = 0
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
      input1 = @hash[@pos].to_i
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
      if @sequence.length == 2
        run_paint(@sequence[0], @sequence[1])
        @sequence = []
      end  
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

A = File.read("aoc_2019_11.txt")
arr = A.split(",").map(&:to_i)

# 1 
run(arr) 

p @count_hash.length

# 2
panel = Array.new(100){Array.new(100)}
@pos = [50,50]
@hash = {@pos => 1}
@dir = "U"
@sequence = []
@count_hash = {}

A = File.read("aoc_2019_11.txt")
arr = A.split(",").map(&:to_i)

run(arr)

for i in 0..panel.length-1
  for j in 0..panel.length-1
    if @hash[[i,j]] == 1
      panel[i][j] = "#"
    else
      panel[i][j] = "."
    end  
  end
end

panel.each do |a|
  p a
end        

