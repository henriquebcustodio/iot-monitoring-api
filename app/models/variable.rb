class Variable < ApplicationRecord
  belongs_to :device

  validates :variable_type, inclusion: { in: %w[boolean numeric text] }
  validates :label, uniqueness: true
end
