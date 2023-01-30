class UserListItem < ApplicationRecord
  # define Associations
  belongs_to :user
  has_one :user_purchase_item

  # point validation
  validates :name, presence: true,
            length: { maximum: 100 }

  # point validation
  validates :point, presence: true,
            numericality: {greater_than_or_equal_to: -1000000,
                           less_than_or_equal_to: 1000000}
end
