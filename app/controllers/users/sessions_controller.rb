module Users
  class SessionsController < ApplicationController
    def create
      user_params = params.require(:user).permit(:email, :password)

      input = {
        email: user_params[:email],
        password: user_params[:password]
      }

      ::Users::Login
        .call(input)
        .on_failure(:not_found) { |data| render_json(404, user: data[:errors]) }
        .on_failure(:invalid_password) { |data| render_json(401, user: data[:errors]) }
        .on_success { |result| render_json(200, token: result[:token]) }
    end

    def validate_token
      authenticate_user
    end
  end
end
