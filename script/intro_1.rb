#!/usr/bin/ruby

$i = 0
$num = 5

while $i < $num  do
  puts("Inside the loop i = #$i")
  $i +=1
end

## variables and constant
a, _ = 1, 2
c,b = [3,4]
puts(a)
puts('b=%d' % b)
puts("c=#{c}")
