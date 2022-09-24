class DataPoint < ApplicationRecord
  belongs_to :variable

  validates :timestamp, presence: true
end
