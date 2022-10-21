class DataPoint < ApplicationRecord
  belongs_to :variable

  delegate :user, to: :variable

  validates :timestamp, presence: true

  def as_json(options = {})
    options.merge!(methods: :value, except: %i[bool_value numeric_value text_value])
    super(options)
  end

  def value
    case variable.variable_type
    when 'boolean'
      bool_value
    when 'numeric'
      numeric_value
    when 'text'
      text_value
    else
      raise NotImplementedError
    end
  end
end
