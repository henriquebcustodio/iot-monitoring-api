FactoryBot.define do
  factory :device do
    name { ::Faker::Name.name }
    label { ::Faker::Device.model_name }
    description { ::Faker::Device.model_name }
    user
  end
end

