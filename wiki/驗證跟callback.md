# intro
[link](https://railsbook.tw/chapters/19-model-validation-and-callback.html)
[Validations 章節](http://guides.rubyonrails.org/active_record_validations.html)

# Callbacks
在資料從 ruby 物件存到資料庫的動作中，包含好幾個連續動作
[link](https://railsbook.tw/images/chapter19/model-lifecycle.png)
可以從這些 callback 去進行一些資料的前處理

## validates
在資料存進去之前，能夠進行一些資料辨識，可藉以 block 不合法的資料存入 db
file:model/store.rb
```ruby
validates :title, presence: true
```
- new 一個 store 後確認是否有錯誤
```ruby
s = Store.new()
s.errors.present?
```
- save 以後會發現出錯
```ruby
s.save
s.errors.present?
s.errors.full_messages
```
### validate
用自訂的方法來增加 validate 步驟，直接寫在 model
```ruby
  validate :address_present 

  private

  def address_present
    unless address.present?
      errors[:address] << '要有 address 喔'
    end
  end
```
### 增加 validates 模組
這邊就要另外寫 class 了, 如果訂的 function 是 begin_with_ruby，就要寫成以下
```ruby
class BeginWithRubyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.starts_with? 'Ruby'
      record.errors[attribute] << "必須是 Ruby 開頭喔!"
    end
  end
end
```
需要另外放在某個地方再導入