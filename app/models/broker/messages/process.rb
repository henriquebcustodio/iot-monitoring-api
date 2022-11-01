module Broker
  module Messages
    class Process < ::Micro::Case
      attribute :topic, validates: { kind: ::String }
      attribute :message, validates: { kind: ::Hash }

      def call!
        topic_id = topic.split('/').last

        device = Device.find_by(topic_id:)

        return Failure(:device_not_found) if device.nil?

        variable = device.variables.find_by(label: message['label'])

        return Failure(:variable_not_found) if variable.nil?

        data_point = ::Devices::Variables::DataPoints::AsHash.call(
          variable:,
          value: message['value'],
          timestamp: message['timestamp']
        ) do |on|
          on.success { |result| result[:data_point] }
          on.failure { nil }
        end

        return Failure(:invalid_data_point) if data_point.nil?

        ::Devices::Variables::DataPoints::BatchWriter.instance.push(data_point)

        ActionCable.server.broadcast(
          "variable_#{variable.id}",
          {
            timestamp: data_point[:timestamp],
            value: [
              data_point[:numeric_value],
              data_point[:bool_value],
              data_point[:text_value]
            ].compact.first
          }
        )

        Success(:message_processed)
      end
    end
  end
end
