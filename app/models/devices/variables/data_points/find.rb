module Devices
  module Variables
    module DataPoints
      class Find < ::Micro::Case
        attributes :id, :user_id

        def call!
          data_point = DataPoint.find_by(id:)

          return Failure(:not_found, result: { errors: { id: ['not found'] } }) if data_point.nil?

          if data_point.user.id != user_id
            return Failure(:forbidden, result: { errors: { id: ['is not available to this user'] } })
          end

          Success(result: { data_point: })
        end
      end
    end
  end
end

