class Device < ApplicationRecord
  belongs_to :user

  validates :label, uniqueness: { scope: :user_id }
end
