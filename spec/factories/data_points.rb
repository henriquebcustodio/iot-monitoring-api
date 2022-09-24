FactoryBot.define do
  factory :data_point do
    numeric_value { rand(30) }

    trait :boolean do
      bool_value { [true, false].sample }
    end

    trait :text do
      text_value { ::Faker::Hacker.ingverb}
    end
  end
end
