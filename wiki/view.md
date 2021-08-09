# intro
[link](https://railsbook.tw/chapters/15-layout-render-and-view-helper.html)

# layout
- 在轉出 html 前的流程，順序是
  - 先確定 layout
    - 先看 method 裡面有沒有指定 layout
    - 去找 app/views/layouts/ 與 controller 同名的 .html.erb/slim，像是 candidates_controller.rb 就會找 candidates.html.erb
    - 沒找到就把共用 layout(app/views/layouts/application.html.erb) 拿來用
  - 再確定 render

- 在 layout 中使用 <%= yield %> 塞入 render 的 html

# render(partial render)
- 在 controller 中的 method 可用以下方式去指定要用來 render 的 template
```shell
#指定 layout
render layout: "backend"
#指定 render
render "index"
# 沒指定就按照慣例
```
- 在 template 裡面也可以用 render 來做嵌套
```ruby
<%= render partial: "form" %>
```
- 通常的使用方式會加上輸入的參數，這樣比較能夠重複利用
```ruby
<%= render partial: "candidate_tr", locals:{candidates: @candidates} %>
```

# view helper
- 位置在 app/helpers
- 基本上不同方法會放在比較相關的 model 裡面，但因為使用時會取方法名，模組載入(以命名順序)，方法名相同時，會被後面的覆蓋過
```ruby
module ApplicationHelper
  def user_gender(gender)
    if gender == 1
      "男"
    elsif gender == 0
      "女"
    else
      "不想說"
    end
  end
end
```
