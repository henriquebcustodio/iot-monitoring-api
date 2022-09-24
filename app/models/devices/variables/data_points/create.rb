module Devices
  module Variables
    module DataPoints
      class Create < ::Micro::Case
        attribute :variable, validates: { kind: Variable }
        attribute :timestamp, validates: { kind: Integer }, default: (Time.now.to_f * 1000).to_i
        attribute :value, validates: { kind: { of: [String, Numeric, TrueClass, FalseClass] } }

        def call!
          timestamp_errors = []
          timestamp_errors << 'must be a positive number' if timestamp.negative?
          timestamp_errors << 'must be in milliseconds' if timestamp.abs.digits.count != 13

          unless timestamp_errors.empty?
            return Failure(:invalid_timestamp, result: { errors: { timestamp: timestamp_errors } })
          end

          data_point = DataPoint.new(
            timestamp: Time.strptime(timestamp.to_s, '%Q'),
            variable:
          )

          case variable.variable_type
          when 'boolean'
            unless [true, false].include?(value)
              return Failure(:invalid_value_type, result: { errors: { value: 'must be boolean' } })
            end

            data_point.bool_value = value

          when 'numeric'
            unless value.is_a?(Numeric)
              return Failure(:invalid_value_type, result: { errors: { value: 'must be numeric' } })
            end

            data_point.numeric_value = value
          when 'text'
            unless value.is_a?(String)
              return Failure(:invalid_value_type, result: { errors: { value: 'must be a string' } })
            end

            data_point.text_value = value
          else
            raise NotImplementedError
          end

          if data_point.save
            Success(result: { data_point: })
          else
            Failure(:validation_error, result: { errors: data_point.errors.as_json })
          end
        end
      end
    end
  end
end
