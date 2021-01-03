require 'set'

A = File.read("aoc_2019_23.txt")
arr = A.split(",").map(&:to_i)

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

@new_y = false
@messages = {}
@receiving1 = {}
@receiving2 = {}
@receiving3 = {}
@receiving4 = {}
@receiving5 = {}
@nat = []
@y_addresses = []

def run(arr, input1, i, r, input_given, idx)
  1.times do
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
      if idx == 0 && [@receiving1.values, @receiving2.values, @receiving3.values, @receiving4.values, @receiving5.values].flatten.compact.length == 0
        if @nat.length == 2
          input1 = @nat.first
          @nat = [@nat.last]
        elsif @nat.length == 1
          input1 = @nat.first
          @nat = []
          @new_y = true
        end  
      else    
        if @receiving1[idx] && @receiving1[idx].first
          input1 = @receiving1[idx].first
          @receiving1[idx] = @receiving1[idx].length == 2 ? [@receiving1[idx].last] : nil
        elsif  @receiving2[idx] && @receiving2[idx].first
          input1 = @receiving2[idx].first
          @receiving2[idx] = @receiving2[idx].length == 2 ? [@receiving2[idx].last] : nil
        elsif @receiving3[idx] && @receiving3[idx].first 
          input1 = @receiving3[idx].first
          @receiving3[idx] = @receiving3[idx].length == 2 ? [@receiving3[idx].last] : nil
        elsif @receiving4[idx] && @receiving4[idx].first 
          input1 = @receiving4[idx].first
          @receiving4[idx] = @receiving4[idx].length == 2 ? [@receiving4[idx].last] : nil
        elsif @receiving5[idx] && @receiving5[idx].first 
          input1 = @receiving5[idx].first
          @receiving5[idx] = @receiving5[idx].length == 2 ? [@receiving5[idx].last] : nil        
        elsif input_given  
          input1 = -1
        end   
      end     
      if modes[0].to_i == 0
        arr[arr[i+1]] = input1
      elsif modes[0].to_i == 1
        arr[i+1] = input1
      else  
        arr[arr[i+1]+r] = input1
      end   
      input_given = true
      i += 2
    elsif opcode == 4
      output = value(modes[0].to_i, arr, i+1, r)
      @messages[idx] ||= []
      if @messages[idx].length < 3
        @messages[idx] << output
      else
        @messages[idx] = [output]
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
  [i,r,input_given]
end

def parameters(dig)
  opcode = dig.to_s.length == 1 ? dig : dig.to_s[-2..-1].to_i
  modes = dig.to_s[0..-3].split("").to_a.reverse
  [opcode, modes]
end

computers = []
for i in 0..49
  computers[i] = arr.dup
end  

indices = [0]*50
input_givens = [false]*50
relatives = [0]*50
answer1_found = false
answer2_found = false
loop do
  for idx in 0..49
    comp = computers[idx].dup
    indices[idx], relatives[idx], input_givens[idx] = run(comp, input_givens[idx] ? -1 : idx, indices[idx], relatives[idx], input_givens[idx], idx)
    computers[idx] = comp.dup
  end   
  @new_messages = {}
  @messages.each do |k,v|
    if v.length == 3
      if v[0] == 255
        @nat = v[1..2]
        if @nat.length == 2 && (@new_y || !@y_addresses.any?)
          if !answer1_found
            p v.last 
            answer1_found = true
          end  
          @y_addresses << v.last
          @new_y = false
          if @y_addresses[-2] == @y_addresses[-1]
            p @y_addresses[-2]
            answer2_found = true
          end  
        end  
      else  
        if !@receiving1[v[0]]
          @receiving1[v[0]] = v[1..2]
        elsif !@receiving2[v[0]]
          @receiving2[v[0]] = v[1..2]
        elsif !@receiving3[v[0]]
          @receiving3[v[0]] = v[1..2]
        elsif !@receiving4[v[0]]
          @receiving4[v[0]] = v[1..2]
        elsif !@receiving5[v[0]]
          @receiving5[v[0]] = v[1..2]
        end 
      end   
    else
      @new_messages[k] = v
    end  
  end
  @messages = @new_messages.clone  
  computers = Marshal.load(Marshal.dump(computers))
  break if answer2_found
end  
