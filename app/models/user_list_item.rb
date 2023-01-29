class UserListItem < ApplicationRecord
  # define Associations
  belongs_to :user
  has_one :user_purchase_item
end
