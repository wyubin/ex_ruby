#!/usr/bin/ruby

# 定義 func
def say_hello(name = 'cat')
  puts "hello, #{name}"
end

say_hello('john')
say_hello 'pig'
send(:say_hello, 'mouse')
say_hello

# mark ?/! 通常是用來註記 def 回傳值的型態與作用，慣例來說，? 用來暗示回傳為 bool，! 則是可能會影響原始輸入

def attr_print(name,options={})
  puts("#{name}:#{options}")
end

attr_print "cat", hair:true, feet:4

# block 為附屬於前一個物件的執行區塊，類似 lambda
3.times do |i|
  puts i
end
3.times {|i| puts i}
## use in function
def print_block
  puts '==block start'
  yield hair:true, feet:4
  yield(hair:false)
  puts '==end'
end

a=print_block{|x| puts("block value:#{x}")}

## as return value when yield
def pick(list)
  result = []
  list.each do |i|
    result << i if yield(i)            # 如果 yield 的回傳值是 true 的話...
  end
  result
end

p pick([*1..10]) { |x| x % 2 == 0 }    # => [2, 4, 6, 8, 10]

## assign block as variable
select_double = Proc.new { |x| x % 2 == 0 }
if select_double.call(2)
  puts "input double"
end

