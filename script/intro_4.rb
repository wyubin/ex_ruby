#!/usr/bin/ruby

# class, 開頭大寫
## initialize
class Cat
  def initialize(name='small cat')
    @name = name
  end

  def meo(food='chicken')
    puts "我是#{@name}, 想吃#{food}"
  end
end

a_cat = Cat.new('貓')
a_cat.meo('乾乾')
#puts a_cat.name

=begin 實體變數
@name 這類的實體變數無法直接 access(僅內部使用)
需另外建方法取用，或是用 attr_accessor
=end

class Dog
  attr_accessor :name

  def initialize(name='大狗')
    @name = name
  end
end

a_dog = Dog.new()
puts a_dog.name

# 定義類別方法用 self,  一般不加的只能用在 instance

class Chicken
  def self.hello(name)
    puts "I am a chick,#{name}"
  end
end
Chicken.hello("貓貓")

# protected/private 內部使用限制
class Mouse
  def hello(name)
    puts "I am a mouse,#{name}"
  end
  private
  def inner_def()
    puts "這是內部方法"
  end
end

a_mouse = Mouse.new()
#a_mouse.inner_def()

## 繼承 是用 < 
## alias, 看起來儘量避免這樣做
class Mouse
  alias :original_hello :hello

  def hello(n)
    puts "first: ha,ha"
    original_hello(n)
  end
end

a_mouse.hello('貓貓')

## module 另外以 include 多加能力... 感覺可能不常用
module Flyable
  def fly
    puts "I can fly!"
  end
end

class ChickenA
  include Flyable
end

fly_chick = ChickenA.new()
fly_chick.fly