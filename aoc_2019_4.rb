def matching?(arr)
  double = arr.each_cons(2).select {|a,b| a==b } 
  triple = arr.each_cons(3).select {|a,b,c| a==b && b== c}
    
  if triple.any?  && double.any?
    if triple.flatten.uniq.length != 1 || (triple.flatten + double.flatten).uniq.length == 1
      return false
    end  
  end  
  true    
end  

count = 0
for i in 178416..676461
  arr = i.to_s.split("")
  if arr.each_cons(2).count {|a,b| a==b} >= 1 && arr.sort == arr
    count += 1
  end
end

p count  

# 2
count = 0
for i in 178416..676461
  arr = i.to_s.split("")
  if arr.each_cons(2).count {|a,b| a==b} >= 1 && matching?(arr) && arr.sort == arr
    count += 1
  end
end

p count    


