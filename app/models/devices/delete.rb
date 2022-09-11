module Devices
  class Delete < ::Micro::Case
    attributes :id, :user_id

    def call!
      device = Device.where(id:, user_id:).first

      return Failure(:not_found, result: { errors: { id: ['not found'] } }) if device.nil?

      device.destroy

      Success(result: { device: 'successfully deleted' })
    end
  end
end
