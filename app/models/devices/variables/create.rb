module Devices
  module Variables
    class Create < ::Micro::Case
      attribute :name, default: ::Utils::ToStrippedString
      attribute :label, default: ::Utils::ToStrippedString
      attribute :description, default: ::Utils::ToStrippedString
      attribute :type, default: ::Utils::ToStrippedString
      attribute :user_id
      attribute :device_id

      def call!
        unless %w[boolean numeric text].include?(type)
          return Failure(:invalid_type, result: { errors: { type: 'should be boolean, numeric or text' } })
        end
        
        device = Device.where(id: device_id, user_id:).first
        
        return Failure(:device_not_found, result: { errors: { id: 'not found' } }) if device.nil?

        variable = Variable.new(
          name:,
          label:,
          description:,
          variable_type: type,
          device:
        )

        if variable.save
          Success(result: { variable: })
        else
          Failure(:validation_error, result: { errors: variable.errors.as_json })
        end
      end
    end
  end
end
