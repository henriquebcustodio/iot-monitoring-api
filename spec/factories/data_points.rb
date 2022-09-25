FactoryBot.define do
  factory :data_point do
    timestamp { Time.now }

    numeric_value { rand(30) }
    variable factory: :variable, variable_type: 'numeric'

    trait :boolean do
      bool_value { [true, false].sample }
      variable factory: :variable, variable_type: 'boolean'
    end

    trait :text do
      text_value { ::Faker::Hacker.ingverb}
      variable factory: :variable, variable_type: 'text'
    end
  end
end
