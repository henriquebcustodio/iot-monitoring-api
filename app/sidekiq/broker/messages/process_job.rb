module Broker
  module Messages
    class ProcessJob < ActiveJob::Base
      queue_as :default

      def perform(messages)
        messages.each do |message|
          ::Broker::Messages::Process.call(topic: message[:topic], payload: message[:payload])
        end
      end
    end
  end
end
