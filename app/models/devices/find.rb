module Devices
  class Find < ::Micro::Case
    attributes :id, :user_id

    def call!
      device = Device.where(id:, user_id:).first

      return Failure(:not_found, result: { errors: { id: ['not found'] } }) if device.nil?

      Success(result: { device: })
    end
  end
end

