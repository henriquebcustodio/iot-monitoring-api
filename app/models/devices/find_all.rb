module Devices
  class FindAll < ::Micro::Case
    attribute :user_id

    def call!
      devices = Device.where(user_id:)

      Success(result: { devices: })
    end
  end
end
