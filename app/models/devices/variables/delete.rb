module Devices
  module Variables
    class Delete < ::Micro::Case
      attribute :variable, validates: { kind: Variable }

      def call!
        variable.destroy

        Success(result: { variable: 'successfully deleted' })
      end
    end
  end
end

