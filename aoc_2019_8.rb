A = File.read("aoc_2019_8.txt")

# 1

a = A.split("").map(&:to_i).each_slice(25*6).to_a
idx = a.each_with_index.map {|b,i| [b.count(0),i]}.sort.first.last
p a[idx].count(1)*a[idx].count(2)

#2

a = a.transpose
b = []
a.each do |c|
  b << c.map {|x| x == 2 ? nil : x}
end

b.map(&:compact).map(&:first).each_slice(25) do |c|
  p c
end  