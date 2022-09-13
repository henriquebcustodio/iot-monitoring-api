FactoryBot.define do
  factory :device do
    name { ::Faker::Name.name }
    label { ::Faker::Device.name }
    description { ::Faker::Device.model_name }
    user
  end
end

