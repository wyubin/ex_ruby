#!/usr/bin/ruby

# string as array
title = '育彬是我的名字'
title[0..1] = '豬'

p title
p "title 長度:#{title.size}"
p "title 位元:#{title.bytesize}"
if title.count('豬') != 0
  p '有豬!!'
end

if !title.empty?
  p "有寫 title"
end

# sub/gsub
puts '育彬是育彬'.sub(/育彬/, '豬')
puts '育彬是育彬'.gsub(/育彬/, '豬')

# array
arrTitle = title.split("")
puts arrTitle.first
puts arrTitle.last

# array method, map/reduce/select
arr_num = 1..3
arr_num.each do |num|
  puts num
end

if [*1..3] == [*1...4]
  puts '1..3 == 1...4'
end

puts arr_num.map {|num| num*2}

puts arr_num.reduce(5) { |x, y| x + y }

puts arr_num.select { |x| x%2 != 0 }

# hash(很像 dict)
hash_tmp = {a:'a',b:1}
## key 是 symbol type 而不是 string
puts hash_tmp[:a]
## methods
puts hash_tmp.keys
puts hash_tmp.values
hash_tmp.each do |key,val|
  puts "key:#{key},value:#{val}"
end

=begin symbol 
很玄，若相同 symbol 通常存在同一個 object_id
操作時效能比較好，
如果要 puts 或是使用字串功能去改變，就用 string
=end
