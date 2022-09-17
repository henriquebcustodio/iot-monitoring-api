module Devices
  module Variables
    class Update < ::Micro::Case
      attribute :name, validates: { kind: { of: [String, nil] } }, default: ::Utils::ToStrippedString
      attribute :label, validates: { kind: { of: [String, nil] } }, default: ::Utils::ToStrippedString
      attribute :description, validates: { kind: { of: [String, nil] } }, default: ::Utils::ToStrippedString
      attribute :type, validates: { kind: { of: [String, nil] } }, default: ::Utils::ToStrippedString
      attribute :variable, validates: { kind: Variable }

      NotNilAndNotBlank = ->(value) { !value.nil? && !value.blank? }

      def call!
        if !label.nil? && label.match(%r{[#+/]})
          return Failure(:invalid_label, result: { errors: { label: 'must not include #, + or / characters' } })
        end

        if !type.nil? && !%w[boolean numeric text].include?(type)
          return Failure(:invalid_type, result: { errors: { type: 'should be boolean, numeric or text' } })
        end

        variable.name = name if NotNilAndNotBlank[name]
        variable.label = label if NotNilAndNotBlank[label]
        variable.description = description unless description.nil?
        variable.variable_type = type if NotNilAndNotBlank[type]

        if variable.save
          Success(result: { variable: })
        else
          Failure(:validation_error, result: { errors: variable.errors.as_json })
        end
      end
    end
  end
end


