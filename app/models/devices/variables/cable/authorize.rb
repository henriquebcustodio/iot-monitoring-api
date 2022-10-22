module Devices
  module Variables
    module Cable
      class Authorize < ::Micro::Case
        attribute :user_id
        attribute :variable_id

        def call!
          variable = Variable.find_by(id: variable_id)

          return Failure(:variable_not_found) if variable.nil?

          return Failure(:unauthorized) if variable.user.id != user_id

          Success(:authorized, result: { variable: })
        end
      end
    end
  end
end
