FactoryBot.define do
  factory :device do
    name { ::Faker::Name.name }
    token { SecureRandom.uuid }
    topic_id { SecureRandom.hex(10) }
    description { ::Faker::Device.model_name }
    user
  end
end

