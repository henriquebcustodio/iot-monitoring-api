module Devices
  class Update < ::Micro::Case
    attribute :name, default: ::Utils::ToStrippedString
    attribute :label, default: ::Utils::ToStrippedString
    attribute :description, default: ::Utils::ToStrippedString
    attribute :id
    attribute :user_id

    def call!
      device = Device.where(id:, user_id:).first
        
      return Failure(:not_found, result: { errors: { id: ['not found'] } }) if device.nil?

      if label.match(%r{[#+/]})
        return Failure(:invalid_label, result: { errors: { label: 'must not include #, + or / characters' } })
      end
        
      device.name = name unless name.blank?
      device.label = label unless label.blank?
      device.description = description unless description.blank?

      if device.save
        Success(:device_updated, result: { device: device.as_json })
      else
        Failure(:validation_error, result: { errors: device.errors.as_json })
      end
    end
  end
end
