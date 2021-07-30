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
*  在 draw 裡面，可用 resources :user 直接啟用以下一堆 mapping, 或是用 only/except 來限制所產生的 mapping
```ruby
Rails.application.routes.draw do
  resources :user
end
```
```text
   Prefix Verb   URI Pattern               Controller#Action
    users GET    /users(.:format)          users#index
          POST   /users(.:format)          users#create
 new_user GET    /users/new(.:format)      users#new
edit_user GET    /users/:id/edit(.:format) users#edit
     user GET    /users/:id(.:format)      users#show
          PATCH  /users/:id(.:format)      users#update
          PUT    /users/:id(.:format)      users#update
          DELETE /users/:id(.:format)      users#destroy
```
```ruby
Rails.application.routes.draw do
  resources :products, only: [:index, :show]
end
```
*  另外"Prefix" 可在加上 "path" 或是 "url" 來輸出網頁的站內路徑或是完整網頁路徑
*  "resource" 與 "resources"的差異則是無法在 url 上面加 :id, 使得使用上面不能指定想要操作的 id
*  resources 可以有巢狀寫法讓相互關聯的controller 能夠自動產生組合 mapping 讓相關 controller 能夠傳遞 _id 使得能夠直接建立關聯性的資料
```ruby
Rails.application.routes.draw do
  resources :users do
    resources :posts, only: [:index, :new, :create]
  end
  resources :posts, only: [:show, :edit, :update, :destroy]
end
```
```text
       Prefix Verb   URI Pattern                         Controller#Action
   user_posts GET    /users/:user_id/posts(.:format)     posts#index
              POST   /users/:user_id/posts(.:format)     posts#create
new_user_post GET    /users/:user_id/posts/new(.:format) posts#new
        users GET    /users(.:format)                    users#index
              POST   /users(.:format)                    users#create
     new_user GET    /users/new(.:format)                users#new
    edit_user GET    /users/:id/edit(.:format)           users#edit
         user GET    /users/:id(.:format)                users#show
              PATCH  /users/:id(.:format)                users#update
              PUT    /users/:id(.:format)                users#update
              DELETE /users/:id(.:format)                users#destroy
    edit_post GET    /posts/:id/edit(.:format)           posts#edit
         post GET    /posts/:id(.:format)                posts#show
              PATCH  /posts/:id(.:format)                posts#update
              PUT    /posts/:id(.:format)                posts#update
              DELETE /posts/:id(.:format)                posts#destroy
```
*  resources 裡面還可以針對不同需求加上不同mapping的url, 就可以用 /orders/cancelled 連到 OrderController 的 cancelled，加上 on: :collection
```ruby
Rails.application.routes.draw do
  resources :orders do
    get :cancelled, on: :collection
  end
end
```
```text
          Prefix Verb   URI Pattern                 Controller#Action
cancelled_orders GET    /orders/cancelled(.:format) orders#cancelled
          orders GET    /orders(.:format)           orders#index
                 POST   /orders(.:format)           orders#create
       new_order GET    /orders/new(.:format)       orders#new
      edit_order GET    /orders/:id/edit(.:format)  orders#edit
           order GET    /orders/:id(.:format)       orders#show
                 PATCH  /orders/:id(.:format)       orders#update
                 PUT    /orders/:id(.:format)       orders#update
                 DELETE /orders/:id(.:format)       orders#destroy
```
*  如果是需要加上"id" 參數，則用 on: :member
```ruby
Rails.application.routes.draw do
  resources :orders do
    post :confirm, on: :member
    delete :cancel, on: :member
  end
end
```
*  resources 中 可以用 path: 來定義想要用的 uri prefix
```ruby
Rails.application.routes.draw do
  resources :products, path: "/admin/products"
end
```
```text
      Prefix Verb   URI Pattern                        Controller#Action
    products GET    /admin/products(.:format)          products#index
             POST   /admin/products(.:format)          products#create
 new_product GET    /admin/products/new(.:format)      products#new
edit_product GET    /admin/products/:id/edit(.:format) products#edit
     product GET    /admin/products/:id(.:format)      products#show
             PATCH  /admin/products/:id(.:format)      products#update
             PUT    /admin/products/:id(.:format)      products#update
             DELETE /admin/products/:id(.:format)      products#destroy
```
*  也可以用 namespace 來做定義，但會變成連 controller rb 的位置都會被區隔開
```ruby
Rails.application.routes.draw do
  namespace :admin do
    resources :products
    resources :articles
  end
end
```
