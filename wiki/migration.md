# intro
資料庫隨著程式開發總是會有修正，如何讓資料庫隨著 git 進行管理更新就是靠migration

# 產生 migration.rb
- 當rails g model 的時候，就會順便產生一個 migration.rb 了，前面會加上時間搓際
- 或是用rails g migration [name] 也可以
- 在從model generate 出來的 migration 通常會有 t.timestamps，經過 rails 會自動產生 created_at 以及 updated_at 兩個時間戳記欄位
```ruby
class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.boolean :is_online

      t.timestamps
    end
  end
end
```

# 執行或修正 migration
- migrate，執行專案中的 migration 修正 db 架構
```shell
rails db:migrate
rails db:migrate RAILS_ENV=production # 修正特定環境下的資料庫
```
- rollback，將db架構往前回朔
```shell
rails db:rollback STEP=3 # STEP 可以設定往前回朔的版本數，預設為1
```
- status，查詢 目標db 的migration 狀態
```shell
rails db:migrate:status
```