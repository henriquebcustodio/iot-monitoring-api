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

      if label.match(%r{[#+/]})
        return Failure(:invalid_label, result: { errors: { label: 'must not include #, + or / characters' } })
      end

      token = SecureRandom.uuid
      topic_id = SecureRandom.hex(10)

      device = Device.new(
        name:,
        description:,
        label:,
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
