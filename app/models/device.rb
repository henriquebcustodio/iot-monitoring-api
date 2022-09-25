class Device < ApplicationRecord
  belongs_to :user
  has_many :variables, dependent: :destroy

  validates :token, :topic_id, uniqueness: true
end
