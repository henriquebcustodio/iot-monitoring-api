class Device < ApplicationRecord
  belongs_to :user
  has_many :variables

  validates :label, uniqueness: { scope: :user_id }
  validates :token, :topic_id, uniqueness: true
end
