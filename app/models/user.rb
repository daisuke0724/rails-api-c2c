class User < ApplicationRecord

  # email validation
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false}

  # password validation
  has_secure_password

  # name validation
  validates :name, presence: true, length: { maximum: 50 }

end