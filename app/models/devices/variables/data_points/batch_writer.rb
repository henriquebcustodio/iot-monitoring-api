require 'concurrent'

module Devices
  module Variables
    module DataPoints
      class BatchWriter < ::BatchProcessor
        include ::Singleton

        private

        def process(data_points)
          data_points.each_slice(1000) do |batch|
            ::RailsPerformance.measure('insert', 'MQTT') do
              DataPoint.insert_all(batch)
            end
          end
        end
      end
    end
  end
end
