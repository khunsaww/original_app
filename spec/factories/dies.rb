FactoryBot.define do
  factory :die do
    sequence(:name) { |n| "ダイス#{n}" }
    sequence(:product_code) { |n| "PC-#{n}" }
    size { "M6×1.0" }
    category { "ヘッダーダイス" }
    association :location
    new_quantity { 10 }
    used_quantity { 0 }
    unit_price { 1000 }
  end
end
