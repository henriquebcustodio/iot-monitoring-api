module Devices
  module Variables
    class Find < ::Micro::Case
      attribute :id, default: ::Utils::ToStrippedString
      attribute :user_id

      def call!
        variable = Variable.find_by(id:)

        return Failure(:not_found, result: { errors: { id: ['not found'] } }) if variable.nil?

        if variable.user.id != user_id
          return Failure(:forbidden, result: { errors: { id: ['is not available to this user'] } })
        end


        Success(result: { variable: })
      end
    end
  end
end
