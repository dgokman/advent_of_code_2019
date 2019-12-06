class Array
  def valid_password?
    double = self.each_cons(2).select {|a,b| a == b } 
    triple = self.each_cons(3).select {|a,b,c| a == b && b == c}
      
    if triple.any? && double.any? && 
      (triple.flatten.uniq.length != 1 || 
      (triple.flatten + double.flatten).uniq.length == 1)
      return false 
    end  
    true    
  end
end  

arrs = []
for i in 178416..676461
  arr = i.to_s.split("")
  if arr.each_cons(2).any? {|a,b| a==b} && arr.sort == arr
    arrs << arr
  end
end

p arrs.length

# 2
p arrs.count {|arr| arr.valid_password?}  


