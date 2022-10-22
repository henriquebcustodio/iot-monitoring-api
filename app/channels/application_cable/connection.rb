module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :user_id

    def connect
      @user_id = authenticate
    end

    private

    def authenticate
      ::Users::Authenticate.call(token: request.params[:token]) do |on|
        on.success { |result| result[:token_payload]["id"] }
        on.failure { reject_unauthorized_connection }
      end
    end
  end
end
