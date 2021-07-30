# introduction
具備整套web service 系統的 ruby framework

# setup env
*  用 rvm 安裝 ruby(2.6.5)後, 再用gem 安裝 rails 及其它套件

# new service
開啟專案通常是以下步驟
*  建專案 => rails new {project_name}
*  裝相關套件 => bundle install
*  開 service => rails s(server), 通常預設 port 3000

# use Scaffold
建立一個有資料庫網頁的快速方式
*  定義 table 基本結構 => rails g scaffold User name email
*  init db => rails db:migrate
*  開 service => rails s(server)
*  http://localhost:3000/users

# Model/MVC
*  控制DB的 interface
*  在 rails 裡面可以在 app/models/*.rb 去設定 models 的功能與關係，一樣有命名規則
*  
## ApplicationRecord
*  關聯性是在 ApplicationRecord > models 的 has_many 跟 belongs_to 去設定
*  可以用 model.first 取用第一個資料，然後就可以用.{model_name} 來 access 關聯的table資料
*  validates 則是套用驗證功能 => validates: content, length:{maximum:20}
*  validates 有幾種 tags:
   *  presence, format, uniqueness, numericality, length, condition
*  可以用scope: 去定義一些 model 的 shorthand 去簡化 controller 需要的操作
*  default_scope 可將class相關操作都多套用此動作，但很危險，注意
*  資料在 save 動作之後，會有以下連續 callback 偵測: valid,before_validation,validate after_validate, before_save, before_create, create, adfer_create, after_save, after_commit，都可以在 ApplicationRecord 設定相關 tag, 可用encrypt_email 作為範例

## CRUD
在 rail 的 model 操作上，主要是new 加上 CRUD(大部分ORM都類似)
### read
有幾個 shorthand
*  first, last
*  find(1), find_by(id:1)
*  find_by_sql()
*  find_each
*  all
*  select('name')
*  where(name:'yubin')
*  order('id DESC') or order(id: :desc)
*  limit(5)
跟summary 相關
*  count, average, sum, maximnm, minimum
### update
*  save
*  update(name:'yubin') or update_attributes(name:'yubin')
*  {class}.update_all(name:'yubin'), 全部更新成name=yubin
*  {model}.increment(:size),  {model}.decrement(:size) => +1 or -1
*  {model}.toggle(:check) => true <=> false
### delete
*  find(1).delete 等同 {class}.delete(1)
*  {class}.destroy_all("price < 10")

# Route/MVC
*  位置會在 app/config/routes.rb，可以在這個檔案裡面定義 routes resource
```ruby
Rails.application.routes.draw do
  get "/posts", to: "posts#index"
  get "/posts/:id", to: "posts#show"
  get '/users', to: redirect('/accounts')
end
```
*  routes.rb 的主要寫法如下，由Rails.application.routes.draw 執行routes 的 mapping:
    *  用 get 所定義的postfix, 用 to: 來對應相關的 controller，像是 /posts 就是去對 PostsController(posts_controller.rb) 的 index, 另外 postfix 中的 ":id" 可以把對應的字串作為 id 變數值傳入 #show
    *  雖然有定義要連 PostsController 的相關 function, 但在開啟routes並不會去檢查相關的controller 狀態
    *  有 redirect def 去做轉址
    *  另外順序是先寫的mapping 會先啟動，後面有相容的 mapping 就會失效

*  可以用 rails routes 去檢查系統中可提供的 routes 對應
*  在 /public 中的 靜態檔案都可以直接從 "/" 以下去 access, 不需要 routes

# controller/MVC
*  位置在 app/controllers，為一個個分開的 rb, 而且命名會與 rails 裡面想使用的class name 有對應關係, ex: PostController => post_controller.rb

# view/MVC
*  位置在 app/views/，通常隨著 controller name分成各個資料夾，會有.erb 檔案藉由 rails 的 erb template engine去render 成 html