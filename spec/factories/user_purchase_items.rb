FactoryBot.define do
  factory :user_purchase_item do
    point { 3000 }

    association :user
  end
end
