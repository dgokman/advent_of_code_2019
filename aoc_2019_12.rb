A = "<x=17, y=5, z=1>
<x=-2, y=-8, z=8>
<x=7, y=-6, z=14>
<x=1, y=-10, z=4>"

moons = A.split("\n").map {|x| x.split(",").map {|y| y[3..-1].to_i}}

def velocity(moons, vel)
  v = []
  moons.transpose.each_with_index do |pos,o|
    idx = (0..pos.length-1).to_a
    subvel = vel[o]
    subv = []
    for i in idx
      others = idx - [i]
      val = subvel[i]
      others.each do |j|
        if pos[i] > pos[j]
          val -= 1
        elsif pos[j] > pos[i]
          val += 1
        end
      end
      subv << val
    end
    v << subv
  end
  v
end

def step(moons, vel)
  new_moons = []
  v = velocity(moons, vel)
  [moons.zip(v.transpose).map {|y| y.transpose.map {|x| x.inject(:+)}}, v]
end

vel = [[0,0,0,0],[0,0,0,0],[0,0,0,0]]
1000.times do 
  moons, vel = step(moons,vel)
end

p moons.map {|a| a.map(&:abs).inject(:+)}.zip(vel.transpose.map {|a| a.map(&:abs).inject(:+)}).map {|a,b| a*b}.inject(:+)

# 2

moons = A.split("\n").map {|x| x.split(",").map {|y| y[3..-1].to_i}}
vel = [[0,0,0,0],[0,0,0,0],[0,0,0,0]]
lcm1, lcm2, lcm3 = nil
steps = 0
until lcm1 && lcm2 && lcm3
  steps += 1
  moons, vel = step(moons,vel)
  if vel[0].uniq == [0]
    lcm1 = steps
  elsif vel[1].uniq == [0]
    lcm2 = steps
  elsif vel[2].uniq == [0] 
    lcm3 = steps 
  end  
end

p lcm1.lcm(lcm2.lcm(lcm3))*2
