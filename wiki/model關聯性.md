# intro 
建立 model 間的關聯性

# 註解
- 應該要有好習慣把註解寫在 model 方便查詢

# belongs_to
當在 model 有相關聯另一個 model 的 id 時, ex user_id 會對應到 User model，就可以在model 裡面設定 belongs_to 來建立一個關聯性方法
```ruby
class Store < ApplicationRecord
  belongs_to :user, optional: true
end
## optional 可以讓 store 可以在沒有 user_id 的狀況下save 到資料庫
```
- 接下來就可以用關聯性來建立資料
```ruby
u = User.last
store1 = Store.new(title:"太空膠囊公司")
store1.user = u
store1.save
```
- 也可以直接從 Store 用 build_user/create_user 直接 new 出關聯性物件
```ruby
store1 = Store.first
store1.build_user(name:'build_by_store')
store1.save
```
會有以下 log
```shell
  TRANSACTION (0.2ms)  begin transaction
  User Create (25.7ms)  INSERT INTO "users" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "build_by_store"], ["created_at", "2021-08-18 04:32:20.334077"], ["updated_at", "2021-08-18 04:32:20.334077"]]
  Store Update (3.3ms)  UPDATE "stores" SET "user_id" = ?, "updated_at" = ? WHERE "stores"."id" = ?  [["user_id", 2], ["updated_at", "2021-08-18 04:32:20.371205"], ["id", 1]]
  TRANSACTION (28.2ms)  commit transaction
=> true
```
```ruby
## create_user 就會直接存user到資料庫，但沒有存關聯性
store1.create_user(name:'create_by_store')
```
log
```shell
  TRANSACTION (0.2ms)  begin transaction
  User Create (30.2ms)  INSERT INTO "users" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "create_by_store"], ["created_at", "2021-08-18 04:37:25.260433"], ["updated_at", "2021-08-18 04:37:25.260433"]]
  TRANSACTION (14.2ms)  commit transaction
=> #<User id: 3, name: "create_by_store", email: nil, created_at: "2021-08-18 04:37:25.260433000 +0000", updated_at: "2021-08-18 04:37:25.260433000 +0000">
```
# has_one
- has_one ，則是在被關聯的 user 物件上也建立一些方便的關聯性方法
```ruby
class User < ApplicationRecord
  has_one :store
end
```
  -  create_store，因為會直接建 store，也會把 user_id 填上，所以這邊有把關聯性寫上去
  ```ruby
  u.create_store(title:'create_by_user')
  ```
  log
  ```shell
    TRANSACTION (0.1ms)  begin transaction
    Store Create (40.7ms)  INSERT INTO "stores" ("title", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "create_by_user"], ["user_id", 3], ["created_at", "2021-08-18 04:45:12.035100"], ["updated_at", "2021-08-18 04:45:12.035100"]]
    TRANSACTION (24.4ms)  commit transaction
  => #<Store id: 2, title: "create_by_user", tel: nil, address: nil, user_id: 3, created_at: "2021-08-18 04:45:12.035100000 +0000", updated_at: "2021-08-18 04:45:12.035100000 +0000">
  ```
# has_many
- has_many，架構上 store 有很多 products
file:product.rb
```ruby
class Product < ApplicationRecord
  belongs_to :store, optional: true
end
```
file:store.rb
```ruby
class Store < ApplicationRecord
  belongs_to :user, optional: true
  has_many :products
end
```
- 可以用 << 的方式增加 product
```ruby
p1 = Product.new(name:'p1')
s = Store.last
s.products << p1
```
log
```shell
  TRANSACTION (0.2ms)  begin transaction
  Product Create (30.6ms)  INSERT INTO "products" ("name", "store_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "p1"], ["store_id", 2], ["created_at", "2021-08-18 06:07:34.932065"], ["updated_at", "2021-08-18 06:07:34.932065"]]
  TRANSACTION (29.8ms)  commit transaction
  Product Load (9.2ms)  SELECT "products".* FROM "products" WHERE "products"."store_id" = ? /* loading for inspect */ LIMIT ?  [["store_id", 2], ["LIMIT", 11]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Product id: 1, name: "p1", description: nil, price: nil, is_available: nil, store_id: 2, created_at: "2021-08-18 06:07:34.932065000 +0000", updated_at: "2021-08-18 06:07:34.932065000 +0000">]>
```
- 可以用 .products.build/create 直接新建 product
```ruby
s.products.build(name:'build_by_store')
s.save
```

# 多對多
會有兩種方式，
- 一種是以手動作第三個 table 來連結兩個資料表，orm 可以用兩個 has_many 來貫通物件之間的聯繫
- 另一個則是用 has_and_belongs_to_many

## has_many * 2
- 先做 WareHouse model
```shell
rails g model WareHouse store:references product:references
rake db:migrate
```
WareHouse model 會直接建好相關性，但 store 跟 product 就要自己加
file:ware_house.rb
```ruby
class WareHouse < ApplicationRecord
  belongs_to :store
  belongs_to :product
end
```
file:store.rb
```ruby
class Store < ApplicationRecord
  belongs_to :user, optional: true
  has_many :ware_houses
  has_many :products, through: :ware_houses
end
```
file:product.rb
```ruby
class Product < ApplicationRecord
  has_many :ware_houses
  has_many :stores, through: :ware_houses
end
```
這樣兩邊都可以用 relation 來操作

## HABTM（has_and_belongs_to_many）
用這個方法就不需要 model ，但還是需要中間的 db table，中間的聯繫則由 rails 的 has_and_belongs_to_many 做掉
- 新增 migration
```shell
rails g migration products_stores
```
file:20210818064625_products_stores.rb
```ruby
class ProductsStores < ActiveRecord::Migration[6.1]
  def change
    create_table :products_stores, id: false do |t|
      t.belongs_to :store, index: true
      t.belongs_to :product, index: true
    end
  end
end
```
- 把 store 跟 product 的 model 都修改過
file:store.rb
```ruby
class Store < ApplicationRecord
  belongs_to :user, optional: true
  has_many :ware_houses
  has_many :products, through: :ware_houses
end
```
file:product.rb
```ruby
class Product < ApplicationRecord
  has_many :ware_houses
  has_many :stores, through: :ware_houses
end
```