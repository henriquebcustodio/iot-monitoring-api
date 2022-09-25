module Broker
  module Devices
    class AuthorizationController < BaseController
      before_action :authenticate_user

      def create
        device_params = params.require(:device).permit(:token)

        input = {
          token: device_params[:token]
        }

        Authorize
          .call(input)
          .on_failure { render_json(403) }
          .on_success { |result| render_json(200, topic_id: result[:topic_id]) }
          .on_unknown { raise NotImplementedError }
      end
    end
  end
end
