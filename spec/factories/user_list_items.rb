FactoryBot.define do
  factory :user_list_item do
    name { "Item1" }
    point { 3000 }

    association :user
  end
end
