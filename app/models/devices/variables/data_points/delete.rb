module Devices
  module Variables
    module DataPoints
      class Delete < ::Micro::Case
        attribute :data_point, validates: { kind: DataPoint }

        def call!
          data_point.destroy

          Success(result: { data_point: 'successfully deleted' })
        end
      end
    end
  end
end


