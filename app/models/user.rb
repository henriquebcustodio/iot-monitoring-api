class User < ApplicationRecord
  has_secure_password
  has_many :devices

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
