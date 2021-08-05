# intro
用一個 cadidate 的頁面做練習
[link](https://railsbook.tw/chapters/13-crud-part-1.html)

[link](https://railsbook.tw/chapters/14-crud-part-2.html)

[Active Record - 資料庫遷移(Migration)](https://ihower.tw/rails/migrations.html)
# route
先新建相關 route, 在 config/routes.rb 裡面直接加
```ruby
resources :candidates
```
就可以用以下確認 route 是否建立
```shell
rails routes
```

# controller
使用 generate controller 把 candidates 需要的 controller 相關檔建起來
```shell
rails generate controller candidates
```
controller 的 rb 會新建到 app/controllers/candidates_controller.rb

# 再來就是資料庫 model
也是用 generate ，把需要的欄位及型態依照規劃建出
```shell
rails generate model candidate name party age:integer politics:text votes:integer
```
db migration 檔會放在 db/migrate
model script 放在 app/models/candidate.rb

## 標注預設職
希望可以在資料庫上面設定預設值，因此需要去 migrate 修改資料，加上, default: 0
```ruby
t.integer :votes, default: 0
```
並進行初始化
```shell
rails db:migrate
```

# view
candidate 的 view 放在 app/views/candidates 去新增所需要的三筆檔案 index, new, edit 的 html.erb
## index 
先新增 controller 的 index function，基本架構如下
```ruby
class CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all
  end
end
```
通常使用區域變數，因在其他地方會拉出來用，所以使用 實體變數
新建 index.html.erb
- new_candidate_path 會指向 new_candidate 的 path
- erb 裡面可以直接使用 controller 裡面的實體變數 @candidates.each

## new
controller 新加
```ruby
def new
  @candidate = Candidate.new
end
```
- Candidate 變數是 model，用 .new function 新增一個實體在 controller 做 @candidate
編輯 new.html.erb
- form_for 可以把 instance 轉出 form 需要的相關屬性
- f.submit 預設送到 create function => 把相關資料經由 model 存到 DB裡
- 如果給 form_for 的 instance 是全新的，會自動在 form 的 html 建立 action 跟 method 是往 /candidate[post] 去送
```html
<form class="new_candidate" id="new_candidate" action="/candidates" accept-charset="UTF-8" method="post">
```
- 所以接下來要建立 create function

## create
- 先將 form 傳過來的 params 送到 new 產生 instance 後，存到 @candidate(可能是另一個 thread 所以不會replace?)
- rails 不允許不做確認直接塞參數進 model，需要做 require 跟
 permit
- 在 if 判斷存檔之後，重連到 show，notice 可以 dialog，不然就render 回去 :new

## edit
- 先從 index.html.erb 放進 edit 的 entry 放進去，順便放 delete 跟 vote
- 因為 candidate_path 有許多 method ，預設是 get ，因此在 delete 需要特別指定
- delete link 中的 data: { confirm: "..." } 可讓 link＿to 多加上  data-confirm，讓 rails 系統在執行 mehtod 前(javascript?) 會先有 confirm dialog
### controller
直接把想編輯的 candidate 使用 model 方法存到 @candiate 就好，之後可以透過 view 塞到 html 中，再經過 save 存到 db
```ruby
def edit
  @candidate = Candidate.find_by(id: params[:id])
end
```
### view
- form_for 會把從 model 找出的 @candidate 轉成是傳到 candidates#update 的 form，因此在送出前，需要準備好 update method
- 另外 edit 跟 new 相同的 html code 佔大部分，因此可以用 render 的方法共用，可以在 view 新增一個 erb(_candidate_form.html.erb)，並將參數改為區域參數
- 使用以下方式就可以做 partial render
```ruby
<%= render "candidate_form", candidate: @candidate %>
```
### update
在 controller 多加一個 update 方法，在 update(orm) 資料後，回連到 show 並 dialog 訊息，不然就一樣連到 render :edit

### delete
在 controller 多加一個 destroy 方法，可以用以下方式同時確認物件存在才 call method
```ruby
@candidate&.destroy
```

## 新加上投票功能 vote
- 投票功能與基本的 CRUD 不太一樣，可以使用 resources 中的 member 加上去(collection 不會加 id)
```ruby
Rails.application.routes.draw do
  resources :candidates do
    member do
      post :vote
    end
  end
end
```
- 查 routes
```shell
vote_candidate POST   /candidates/:id/vote(.:format)                                                                    candidates#vote
```
- 可以去修正 vote 在 index.html.erb 上面的進入點了
```ruby
<td><%= link_to "Vote this", vote_candidate_path(candidate), method: 'post', data:{confirm:'投了！'} %></td>
```
- 新增 vote method 到 controller

# 將 vote 改成一個完整的 votes model
vote 現在僅是一個數字欄位，當要記錄其他相關資訊時便需要 extend
- 希望能夠同時紀錄時間及投票 ip，rails orm 會自動多加 timestamp, 所以只要加 candidate:references 跟 ip_address 就好
```shell
rails generate model vote_log candidate:references ip_address:string
# 隨後 migrate
rails db:migrate
```
## 設定關聯性
關聯性的設定會在 model ，會需要做
- 在 Candidate model 設定 has_many :vote_logs，dependent: :destroy 是指 candidate 做 destroy 時，相關 vote_log 也需要做
```ruby
has_many :vote_logs, dependent: :destroy
```
- 在 VoteLog model 設定，如在 generate model 時已經加 candidate:references ，通常 belong_to 已經加好。
```ruby
belongs_to :candidate
```
## 修改 candidates#vote
因為已經有了 VoteLog 這樣的 model，因此就可以把 vote method 改存到 VoteLog
```ruby
  def vote
    @candidate = Candidate.find_by(id: params[:id])
    @candidate.vote_logs&.create(ip_address: request.remote_ip)
    redirect_to candidates_path, notice: '完成 vote!'
  end
```
## 修正計票方法
修改index.html.erb
```ruby
<td><%= candidate.vote_logs.count %></td>
```
因此會多次 count 造成回應時間變長，可用 cache 方法讓 vote count 暫存在 candidate 的欄位

## 產生暫存欄位
```shell
rails generate migration add_counter_to_candidate vote_logs_count:integer
```
會產生一個新的 migration rb，但實際上也可以自己寫
```ruby
class AddCounterToCandidate < ActiveRecord::Migration[6.1]
  def change
    rename_column :candidates, :votes, :vote_logs_count
  end
end
```
- 將原本計算的 :votes 改成 :vote_logs_count，就可以使用 rails 的慣例自動加總，需要修正 VoteLog model
```ruby
class VoteLog < ApplicationRecord
  belongs_to :candidate, counter_cache: true
end
```
- 在 VoteLog 增加時，就會在 candidate 的 vote_logs_count 加1
## 再修正 index.html.erb
需要再把裡面的 candidate.vote_logs.count 改成以下
```ruby
<td><%= candidate.vote_logs_count %></td>
```
如此可以減少 sql 執行次數

# 精簡程式碼
## before_action
使用 controller 方法把各個 method 都會執行的動作集合程式碼到同一個描述
- before_action 可以(選擇)哪些 method 做同一個動作
- 先補 private 方法 find_candidate，然後請 before_action 執行