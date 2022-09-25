module Devices
  class Create < ::Micro::Case
    attributes :name, :description, default: ::Utils::ToStrippedString
    attribute :user, validates: { kind: User }

    def call!
      errors = {}
      errors[:name] = ["can't be blank"] if name.blank?

      return Failure(:blank_arguments, result: { errors: }) unless errors.empty?

      token = SecureRandom.uuid
      topic_id = SecureRandom.hex(10)

      device = Device.new(
        name:,
        description:,
        token:,
        topic_id:,
        user:
      )

      if device.save
        Success(:device_created, result: { device: })
      else
        Failure(:validation_error, result: { errors: device.errors.as_json })
      end
    end
  end
end
