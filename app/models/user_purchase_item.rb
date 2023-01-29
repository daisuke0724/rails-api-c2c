class UserPurchaseItem < ApplicationRecord
  # define Associations
  belongs_to :user
  belongs_to :user_list_item
end
