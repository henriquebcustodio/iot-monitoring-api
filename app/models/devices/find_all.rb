module Devices
  class FindAll < ::Micro::Case
    attribute :user_id

    def call!
      devices = Device.where(user_id:).order(:id)

      Success(result: { devices: })
    end
  end
end
