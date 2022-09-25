class Variable < ApplicationRecord
  belongs_to :device

  has_many :data_points, dependent: :destroy

  delegate :user, to: :device

  validates :variable_type, inclusion: { in: %w[boolean numeric text] }
  validates :label, uniqueness: true
end
