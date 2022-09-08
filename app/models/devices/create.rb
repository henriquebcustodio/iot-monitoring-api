module Devices
  class Create < ::Micro::Case
    attribute :name, default: ::Utils::ToStrippedString
    attribute :label, default: ::Utils::ToStrippedString
    attribute :description, default: ::Utils::ToStrippedString
    attribute :user, validates: { kind: User }

    def call!
      errors = {}
      errors[:name] = ["can't be blank"] if name.blank?
      errors[:label] = ["can't be blank"] if label.blank?

      return Failure(:blank_arguments, result: { errors: }) unless errors.empty?

      token = generate_token

      device = Device.new(
        name:,
        description:,
        label:,
        token:,
        user:
      )

      if device.save
        Success(:device_created, result: { device: device.as_json })
      else
        Failure(:validation_error, result: { errors: device.errors.as_json })
      end
    end

    private

    def generate_token
      SecureRandom.uuid
    end
  end
end
