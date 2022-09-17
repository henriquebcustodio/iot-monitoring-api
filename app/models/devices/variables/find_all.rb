module Devices
  module Variables
    class FindAll < ::Micro::Case
      attribute :device, validates: { kind: Device }

      def call!
        variables = device.variables

        Success(result: { variables: })
      end
    end
  end
end

