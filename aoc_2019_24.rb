A = "####.
#....
#..#.
.#.#.
##.##"

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

field = A.split("\n").map {|x| x.split("")}
new_field = Marshal.load(Marshal.dump(field))

array = []
sum = 0
300.times do
  i = 0
  j = 0
  while i < field.length
    while j < field[i].length
      adjacent_acres = [field.fetch(i-1).fetch(j), 
          field.fetch(i).fetch(j-1), field.fetch(i+1).fetch(j), 
          field.fetch(i).fetch(j+1)]

      if field[i][j] == "#"
        if adjacent_acres.count("#") != 1
          new_field[i][j] = "."
        end
      end
      if field[i][j] == "."  
        if adjacent_acres.count("#").between?(1,2)
          new_field[i][j] = "#"
        end
      end  
      
      j += 1

    end
    i += 1
    j = 0
  end  

  array << new_field.flatten.join
  field = Marshal.load(Marshal.dump(new_field))

  new_field = Marshal.load(Marshal.dump(field))
  doubles = array.select {|a| array.count(a) == 2}
  if doubles.any?
    i = 0
    doubles.first.split("").each do |b|
      if b == "#"
        sum += 2**i
      end
      i += 1
    end
    break
  end  
end

p sum