FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:nickname) { |n| "ユーザー#{n}" }
    last_name { "山田" }
    first_name { "太郎" }
    last_name_kana { "ヤマダ" }
    first_name_kana { "タロウ" }
    birthday { Date.new(1990, 1, 1) }
    password { "password" }
    role { :general }

    trait :admin do
      nickname { "管理者" }
      last_name { "管理" }
      first_name { "花子" }
      last_name_kana { "カンリ" }
      first_name_kana { "ハナコ" }
      role { :admin }
    end
  end
end
