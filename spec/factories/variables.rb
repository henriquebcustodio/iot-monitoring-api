FactoryBot.define do
  factory :variable do
    name { ::Faker::Hacker.abbreviation }
    label { ::Faker::Hacker.abbreviation }
    description { ::Faker::Hacker.say_something_smart }
    variable_type { %w[boolean numeric text].sample }
    device
  end
end

