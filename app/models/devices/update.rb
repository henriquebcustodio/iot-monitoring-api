module Devices
  class Update < ::Micro::Case
    attributes :name, :description, default: ::Utils::ToStrippedString
    attributes :id, :user_id

    def call!
      device = Device.where(id:, user_id:).first
        
      return Failure(:not_found, result: { errors: { id: ['not found'] } }) if device.nil?
        
      device.name = name unless name.blank?
      device.description = description unless description.blank?

      if device.save
        Success(:device_updated, result: { device: })
      else
        Failure(:validation_error, result: { errors: device.errors.as_json })
      end
    end
  end
end
