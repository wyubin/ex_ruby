# intro
介紹 model 用法
# ref
[link](https://railsbook.tw/chapters/16-model-basic.html)

# create
- .new 僅是建立物件，需要後續 .save 才會 insert 到資料庫
```ruby
user = Candidate.new(name: "孫悟空", age: 18)
user.save
```
- 也可以直接用 .create 直接存到資料庫，如果要直接 exception就是用 create!
```ruby
Candidate.create(name: "孫悟空", age: 18)
```

# read
- first
```ruby
user = Candidate.first        # 取得第 1 筆資料
users = Candidate.first(3)    # 取出前 3 筆資料並存放在陣列裡
```
- order，欄位名需要具備sql實體欄位
```ruby
Candidate.order(age: :desc).first   # 取出年紀最大的候選人
```
- find/find_by，.find 如果失敗會 raise exception，需要額外處理
```ruby
Candidate.find(1)
Candidate.find_by(id: 1)
```
- Exception 處理方式
  - 可以在上下文使用 begin...rescue   處理(有點像是 try except)
  ```ruby
  def find_candidate
    begin
      @candidate = Candidate.find(params[:id])
    rescue
      redirect_to candidates_path, notice: "查無此候選人"
    end
  end
  ```
  - 系統化的方式適用 controller rescue_from 方法，一樣是寫 private 方法然後在 rescue_from 引入
  ```ruby
  class ApplicationController < ActionController::Base
    # ... [略] ...
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private
    def record_not_found
      render plain: "查無資料", status: 404
    end
  end
  ```
  - where，可用