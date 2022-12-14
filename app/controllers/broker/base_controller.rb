module Broker
  class BaseController < ApplicationController
    private

    def authenticate_broker
      token = request.headers['Authorization']&.split(' ')&.last

      ::Broker::Authenticate
        .call(token:)
        .on_failure { render_json(401) }
    end
  end
end
