module Devices
  module Variables
    class Create < ::Micro::Case
      attributes :name, :label, :type, :description, default: ::Utils::ToStrippedString
      attribute :device

      def call!
        errors = {}
        errors[:name] = ["can't be blank"] if name.blank?
        errors[:label] = ["can't be blank"] if label.blank?

        return Failure(:blank_arguments, result: { errors: }) unless errors.empty?

        if label.match(%r{[#+/]})
          return Failure(:invalid_label, result: { errors: { label: 'must not include #, + or / characters' } })
        end

        unless %w[boolean numeric text].include?(type)
          return Failure(:invalid_type, result: { errors: { type: 'should be boolean, numeric or text' } })
        end

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
