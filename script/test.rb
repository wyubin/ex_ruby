#!/usr/bin/ruby

$i = 0
$num = 5

while $i < $num  do
  puts("Inside the loop i = #$i")
  $i +=1
end

module Trig
  PI=3.14
  def Trig.sin(x)
  end
end
