A = "####.
#....
#.?#.
.#.#.
##.##"

B = ".....
.....
..?..
.....
....."

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

L = 200
levels = []


field = A.split("\n").map {|x| x.split("")}
new_field = Marshal.load(Marshal.dump(field))

bare_field = B.split("\n").map {|x| x.split("")}

level = L*2
levels[level] = new_field
for i in (0..level*2).to_a.reject {|a| a == level}
  levels[i] = Marshal.load(Marshal.dump(bare_field))
end  

sum = 0
L.times do |time|
  new_levels = []
  levels[1..-2].each_with_index do |field, idx|
    idx = idx+1
    new_field = Marshal.load(Marshal.dump(field))
    i = 0
    j = 0
    
    while i < field.length
      while j < field[i].length
        nil_level = levels[idx-1]
        adjacent_acres = [field.fetch(i-1).fetch(j) || nil_level[1][2], 
            field.fetch(i).fetch(j-1) || nil_level[2][1], 
            field.fetch(i+1).fetch(j) || nil_level[3][2], 
            field.fetch(i).fetch(j+1) || nil_level[2][3]]

        grid_idx = adjacent_acres.index("?")
        adjacent_level = levels[idx+1]
        new_grid_count =
          case grid_idx
          when 0
            adjacent_level.last.count("#")
          when 1
            adjacent_level.map {|a| a.last}.count("#")  
          when 2
            adjacent_level.first.count("#") 
          when 3
            adjacent_level.map {|a| a.first}.count("#")  
          else
            0
          end
            
        if field[i][j] == "#"
          if (new_grid_count+adjacent_acres.count("#")) != 1
            new_field[i][j] = "."
          end
        end
        if field[i][j] == "."  
          if (new_grid_count+adjacent_acres.count("#")).between?(1,2)
            new_field[i][j] = "#"
          end
        end 
        j += 1

      end
      i += 1
      j = 0
    end  
    new_levels[idx] = Marshal.load(Marshal.dump(new_field))
  end

  levels = Marshal.load(Marshal.dump(new_levels))  
end  

p levels.flatten.join.count("#")