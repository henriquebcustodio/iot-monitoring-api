module Devices
  module Variables
    module DataPoints
      class FindAll < ::Micro::Case
        attribute :variable, validates: { kind: Variable }

        def call!
          data_points = variable.data_points.order(timestamp: :desc)

          Success(result: { data_points: })
        end
      end
    end
  end
end


