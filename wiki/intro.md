# introduction
基本需要熟悉的語法

## general
*  p, puts, print 都是印出的命令, 可以括號也可以不用
*  執行結尾可用分號或不用
*  多行註解用 =begin =end

## variables and constant
*  通常都是區域變數, 可用$ 定義全域, @ 實體 @@ 類別
*  支援 unpack variables
*  constant 是直接開頭大寫

## string and integer
*  雙引號跟單引號都可以，但單引號沒辦法 format 變數進去
*  use '.' to concat between strings
*  也可以用 %Q() 或 %q() 將內容變成字串, 分別等同雙引號及單引號
*  

## class
*  initialize 相當於 python 物件的 __init
*  以 "self." 來判斷是類別的方法
*  一般不能外部讀取實體變數，但可以設定 attr_accessor:{變數名} 來控制

## 判斷式
*  僅需要下一行縮行，不需要':', 但需要end 結尾
*  可以直接把判斷寫在後面
*  可以用類似js 的寫法 status = (age >= 18)? "adult":"child"
*  try 在 ruby 裡面是用 begin ... rescue ...

## 迴圈
*  for name in names 等於 names.each do |name|

## Array
*  簡單的 shorthand 有 first,last,length
*  map 可以用block 去 return 每個 item 的 return => names.map() {|x,y| x+y}
*  select 則是依據return 值的 true/false 去做 array filter
*  reduce 則是把 items 累積運算 => aa.reduce {|x,y| x+y}

## hash
*  有點像 python 的 dict, 但方法很多[link](https://ruby-doc.org/core-3.0.0/Hash.html)

## symbol
看起來是一個在固定記憶體位置的"值" [link](https://ruby-doc.org/core-3.0.0/Symbol.html)

## def
*  可用預設參數

## require 

## block
*  有點像是 python 的 lambda, 但需要所依附的物件有"yield" triger
*  可以用 block_given? 來 return bool 在 def 中確認 block 是否存在
### Proc
可以用來將 block 轉成物件
add_two = Proc.new {|n| n+2} 等同 lambda {|n|n+2} 等同 -> (n) {n+2}
add_two.call(3) or add_two[3]
