class UserPurchaseItem < ApplicationRecord
  # define Associations
  belongs_to :user

  # point validation
  validates :point, presence: true,
            numericality: {greater_than_or_equal_to: -1000000,
                           less_than_or_equal_to: 1000000}
end
