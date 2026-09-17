FactoryBot.define do
  factory :quantity_change do
    association :die
    association :user
    new_quantity_before { 10 }
    new_quantity_after { 8 }
    used_quantity_before { 0 }
    used_quantity_after { 1 }
  end
end
