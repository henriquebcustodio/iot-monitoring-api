require 'mqtt'

module Broker
  module Messages
    module Monitor
      extend self
      
      def start
        setup_client
        subscribe_to_wildcard
      end

      def setup_client
        @client = ::MQTT::Client.connect(
          host: ENV['BROKER_HOST'],
          port: ENV['BROKER_PORT'],
          username: ENV['BROKER_TOKEN']
        )
      end

      def subscribe_to_wildcard
        Thread.new do
          @client.get('#') do |topic, message|
            process_message(topic, message)
          end
        end
      end

      def process_message(topic, message)
        parsed_message = Parse[message]

        return if parsed_message.nil?

        parsed_message[:timestamp] = ::DateTime.now.strftime('%Q').to_i unless parsed_message[:timestamp]

        BatchProcessor.instance.push(topic:, payload: parsed_message)
      end

      private_class_method :setup_client, :subscribe_to_wildcard
    end
  end
end

