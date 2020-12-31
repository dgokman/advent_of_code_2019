A = File.read("aoc_2019_25.txt")

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

def run(arr, input1="")
  string = ""
  i = 0
  output = 0
  r = 0
  input_idx = 0
  inputs = input1.split("").map {|a| a.ord}
  password_found = false
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
      string << output.chr
      passwords = string.scan(/\d+/)

      if passwords.any?
        password_found = true
      end   
      if password_found && passwords.last.length > 1 && output.chr == " "
        return passwords.last
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

# played the game manually to get to password room
# loop all through all combinations of items to drop, except boulder which is always required

items = ["cake",
"pointer",
"fuel cell",
"mutex",
"antenna",
"tambourine",
"coin"]

possible_drops = []
for i in 4..items.length
  items.combination(i).each do |combo|
    possible_drops << combo.map {|a| "drop " + a}.join("\n")
  end
end

possible_drops.each do |drop|
  arr = A.split(",").map(&:to_i)
  password = run(arr, "north\neast\ntake cake\nnorth\nsouth\nwest\neast\neast\nnorth\ntake pointer\nsouth\nwest\nwest\nsouth\nwest\nwest\nwest\ntake coin\neast\nnorth\nsouth\nwest\neast\neast\neast\nnorth\nnorth\ntake mutex\neast\ntake antenna\ninv\nwest\nsouth\nsouth\nwest\nwest\nwest\neast\nnorth\nsouth\nwest\neast\neast\neast\neast\neast\ntake tambourine\neast\ntake fuel cell\neast\ntake boulder\nnorth\n#{drop}\neast\n")
  if password.to_i > 0
    puts password
    break
  end  
end  


