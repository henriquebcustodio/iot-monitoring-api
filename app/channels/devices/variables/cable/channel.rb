module Devices
  module Variables
    module Cable
      class Channel < ::ApplicationCable::Channel
        def subscribed
          variable = authorize

          return reject if variable.nil?

          stream_from "variable_#{variable.id}"
        end

        private

        def authorize
          input = {
            user_id:,
            variable_id: params[:variable_id]
          }

          Authorize.call(input) do |on|
            on.success { |result| result[:variable] }
            on.failure { nil }
          end
        end
      end
    end
  end
end
