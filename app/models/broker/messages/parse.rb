module Broker
  module Messages
    class Parse < ::Micro::Case
      attribute :message, validates: { kind: String }

      def call!
        parsed_message = ::JSON.parse(message)

        Success(:message_parsed, result: { message: parsed_message })

      rescue ::StandardError
        Failure(:parsing_failed)
      end
    end
  end
end
