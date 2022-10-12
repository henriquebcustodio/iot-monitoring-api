module Devices
  module Variables
    module DataPoints
      class AsHash < ::Micro::Case
        attribute :variable, validates: { kind: Variable }
        attribute :timestamp, validates: { kind: Integer }
        attribute :value, validates: { kind: { of: [String, Numeric, TrueClass, FalseClass] } }

        def call!
          timestamp_errors = []
          timestamp_errors << 'must be a positive number' if timestamp.negative?
          timestamp_errors << 'must be in milliseconds' if timestamp.abs.digits.count != 13

          unless timestamp_errors.empty?
            return Failure(:invalid_timestamp, result: { errors: { timestamp: timestamp_errors } })
          end

          data_point = {
            timestamp: Time.strptime(timestamp.to_s, '%Q').utc,
            variable_id: variable.id
          }

          case variable.variable_type
          when 'boolean'
            unless [true, false].include?(value)
              return Failure(:invalid_value_type, result: { errors: { value: 'must be boolean' } })
            end

            data_point[:bool_value] = value

          when 'numeric'
            unless value.is_a?(Numeric)
              return Failure(:invalid_value_type, result: { errors: { value: 'must be numeric' } })
            end

            data_point[:numeric_value] = value
          when 'text'
            unless value.is_a?(String)
              return Failure(:invalid_value_type, result: { errors: { value: 'must be a string' } })
            end

            data_point[:text_value] = value
          else
            raise NotImplementedError
          end

          Success(result: { data_point: })
        end
      end
    end
  end
end

