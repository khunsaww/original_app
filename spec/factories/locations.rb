FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "保管場所#{n}" }
    description { "説明" }
  end
end
