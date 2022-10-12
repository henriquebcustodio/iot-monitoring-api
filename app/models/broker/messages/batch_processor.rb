require 'concurrent'

module Broker
  module Messages
    class BatchProcessor < ::BatchProcessor
      include ::Singleton

      private

      def process(messages)
        messages.each_slice(1000) do |batch|
          ::Broker::Messages::ProcessJob.perform_later batch
        end
      end
    end
  end
end
