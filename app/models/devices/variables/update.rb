module Devices
  module Variables
    class Update < ::Micro::Case
      attributes :name, :label, :type, default: ::Utils::ToStrippedString
      attribute :description, default: ->(val) { val.nil? ? nil : ::Utils::ToStrippedString[val] }
      attribute :variable, validates: { kind: Variable }

      def call!
        if label.match(%r{[#+/]})
          return Failure(:invalid_label, result: { errors: { label: 'must not include #, + or / characters' } })
        end

        if !type.blank? && !%w[boolean numeric text].include?(type)
          return Failure(:invalid_type, result: { errors: { type: 'should be boolean, numeric or text' } })
        end

        variable.name = name unless name.blank?
        variable.label = label unless label.blank?
        variable.description = description unless description.nil?

        unless type.blank? || variable.variable_type == type
          variable.variable_type = type
          variable.data_points.destroy_all
        end

        if variable.save
          Success(result: { variable: })
        else
          Failure(:validation_error, result: { errors: variable.errors.as_json })
        end
      end
    end
  end
end


