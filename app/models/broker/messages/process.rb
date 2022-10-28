module Broker
  module Messages
    class Process < ::Micro::Case
      attribute :topic
      attribute :payload, validates: { kind: ::Hash }

      def call!
        topic_id = topic.split('/').last

        device = Device.find_by(topic_id:)

        return Failure(:device_not_found) if device.nil?

        payload.each do |label, data|
          variable = device.variables.find_by(label:)

          break if variable.nil?

          value = data['value']

          data_point = ::Devices::Variables::DataPoints::AsHash.call(
            variable:,
            value:,
            timestamp: payload[:timestamp]
          ) do |on|
            on.success { |result| result[:data_point] }
            on.failure { nil }
          end

          next if data_point.nil?

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
        end

        Success(:messaged_processed)
      end
    end
  end
end
