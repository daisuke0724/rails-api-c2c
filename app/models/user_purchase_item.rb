class UserPurchaseItem < ApplicationRecord
  belongs_to :user
  belongs_to :user_list_item
end
