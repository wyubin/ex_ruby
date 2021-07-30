# introduction
試著實作簡單的 web service 來了解每個部分的連結的方式

*  先增加一串新的 routes 並確認
```ruby
Rails.application.routes.draw do
  get "hello", to: "pages#hello"
  post "hello/check_name", to: "pages#check_name"
  
  resources :candidates
  resources :users
end
```
*  再來是 controller，可以先用 rails 的功能產生一個 template，主要指令是 "rails generate controller"
```shell
rails generate controller candidates
```
*  建立 model 先要確定 colname and type, 預設 type=string ，以下指令就可以產生 
```shell
rails generate model candidate name party age:integer politics:text votes:integer
```

*  若是需要細部調整 db 的設定，像是預設值之類的，便需要進 app/db/migrate 修改檔案,之後再用 rails db:migrate 將 db table 產出
```ruby
class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :party
      t.integer :age
      t.text :politics
      t.integer :votes, default:0

      t.timestamps
    end
  end
end
```
## controller to views
view 的部分則是經過修改 controller 及對應的 html.erb 檔來串接
### index
*  app/controllers/candidates_controller.rb，先index列出 所有的 candidates，使用 model 的 .all
```ruby
class CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all
  end
end
```
*  app/views/candidates/index.html.erb 包含幾個
    *  new_candidate_path 會直接將所設定的文字連結到 "/candidates/new"
```html
<h1>candidates list</h1>

<%= link_to "新增候選人", new_candidate_path %>

<table>
  <thead>
    <tr>
      <td>候選人姓名</td>
      <td>政黨</td>
      <td>政見</td>
      <td>得票數</td>
    </tr>
  </thead>
  <tbody>
    <% @candidates.each do |candidate| %>
    <tr>
      <td><%= candidate.name %>(age：<%= candidate.age %>)</td>
      <td><%= candidate.party %></td>
      <td><%= candidate.politics %></td>
      <td><%= candidate.votes %></td>
    </tr>
    <% end %>
  </tbody>
</table>
```
### new
一樣，也是先 controller，再加 view
*  在 routes.rb 僅先加入一個區域變數 @candidate 用 model .new
```ruby
class CandidatesController < ApplicationController
  # .. [略] ..

  def new
    @candidate = Candidate.new
  end
end
```
*  app/views/candidates/new.html.erb ，在 form_for 傳入變數轉成  FormBuilder 物件，f 再依需求，轉成對應的 html tag，就不用自己手刻
```html
<h1>add candidate</h1>

<%= form_for(@candidate) do |f| %>
  <%= f.label :name, "name" %>
  <%= f.text_field :name %> <br />

  <%= f.label :age, "age" %>
  <%= f.text_field :age %> <br />

  <%= f.label :party, "party" %>
  <%= f.text_field :party %> <br />

  <%= f.label :politics, "politics" %>
  <%= f.text_area :politics %> <br />

  <%= f.submit %>
<% end %>

<br />
<%= link_to 'back to list', candidates_path %>
```

### create
因為在建立時僅需要 controller 動作，所以這裡沒有 erb
```ruby
class CandidatesController < ApplicationController
  # .. [略] ..

  def create
    @candidate = Candidate.new(candidate_params)

    if @candidate.save
      # 成功
      redirect_to candidates_path, notice: "新增候選人成功!"
    else
      # 失敗
      render :new
    end
  end
  private
  def candidate_params
    params.require(:candidate).permit(:name, :age, :party, :politics)
  end
end
```
*  在 .new 裡面會檢查輸入物件的變數，因此會需要另外做一個 candidate_params 來過濾掉不需要的attr，另外這個def 也只要是 private就可以。
*  .save 會直接輸出 true/nil
*  "render :new" 則是指用 "new.html.erb" 來 render，但因為 @candidate 有值，所以會順便把已經存在的值送進 form

### edit
以下再加上投票，編輯跟刪除的動作
*  index.html.erb，加上以上動作的連結
```html
# .. [略] ..
  <tbody>
    <% @candidates.each do |candidate| %>
    <tr>
      <td><%= link_to "投給這位", "#" %></td>
      <td><%= candidate.name %>(年齡：<%= candidate.age %> 歲)</td>
      <td><%= candidate.party %></td>
      <td><%= candidate.politics %></td>
      <td><%= candidate.votes %></td>
      <td>
        <%= link_to "編輯", edit_candidate_path(candidate) %>
        <%= link_to "刪除", candidate_path(candidate), method: "delete", data: { confirm: "確認刪除" } %>
      </td>
    </tr>
    <% end %>
  </tbody>
</table>
```
*  link_to [連結描述], [uri or path function], ... , 另外預設的 method 應該是 GET, 如果不是要加註。