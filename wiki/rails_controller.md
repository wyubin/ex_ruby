# controller/MVC
*  位置在 app/controllers，為一個個分開的 rb, 而且命名會與 rails 裡面想使用的class name 有對應關係, ex: PostController => post_controller.rb

## new controller
*  新增 controller 可以直接用 rails 指令，就像開新專案一樣，就可以在 app/controllers/pages_controller.rb 看到
```shell
rails g controller pages
```
*  在 route 上面先加上想設計的 controller mapping
```ruby
Rails.application.routes.draw do
  get "hello", to: "pages#hello"
  resources :users
end
```
*  再修改 pages_controller 產生對應頁面，主要是用 "render" 將後面的 plain 字串轉成 res body 
```ruby
class PagesController < ApplicationController
  def hello
    render plain: "<h2>HELLLOOO</h2>"
  end
end
```

## add view
*  render 方式可以不透過 template 去呈現，但如果是需要呈現較複雜的畫面，還是需要 erb，預設會直接去找 app/views/[controller]/[action].html.erb，像是這個就會預設找 app/views/pages/hello.html.erb
```html
<h1>Hello...</h1>
<h2>it's .erb file for hello action</h2>
```
*  query string 的傳遞在 controller 裡面是被 parse 成 params 變數，木並沒有分 GET 跟 POST，可以修改成以下方式檢閱，在 params 裡面還會紀錄 controller and action
```ruby
class PagesController < ApplicationController
  def hello
    render json: params
  end
end
```

## form
將 hello 多加一個確認名字的 form，嵌入的方式"<%=" 跟 "%>"
*  revise app/views/pages/hello.html.erb
```html
<h1>Hello...</h1>
<h2>it is .erb file for hello action</h2>

<h2>check your name</h2>
<%= form_tag '/hello/check_name' do %>
  姓名：<%= text_field_tag 'user_name' %><br />
  <%= submit_tag "確認姓名" %>
<% end %>
```
*  app/config/routes.rb 加上 "hello/check_name" post uri
```ruby
Rails.application.routes.draw do
  get "hello", to: "pages#hello"
  post "hello/check_name", to: "pages#check_name"
  resources :users
end
```
*  增加 check_name action 及 html.erb
```ruby
class PagesController < ApplicationController
  def hello
    #render json: params
  end
  def check_name
    @user_name = params[:user_name]
  end
end
```
*  app/views/pages/check_name.html.erb
```html
```
