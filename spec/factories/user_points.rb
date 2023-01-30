FactoryBot.define do
  factory :user_point do
    point { 10000 }
    association :user
  end
end
