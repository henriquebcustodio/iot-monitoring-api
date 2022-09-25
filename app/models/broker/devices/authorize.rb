module Broker
  module Devices
    class Authorize < ::Micro::Case
      attribute :token

      def call!
        device = ::Device.find_by(token:)

        return Failure(:unauthorized) if device.nil?

        Success(:authorized, result: { topic_id: device.topic_id })
      end
    end
  end
end
