module Users
  class RegistrationsController < ApplicationController

    def create
      user_params = params.require(:user).permit(:email, :password, :password_confirmation)

      input = {
        email: user_params[:email],
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      }

      ::Users::Register
        .call(input)
        .on_failure(:validation_error) { |data| render_json(422, user: data[:errors]) }
        .on_failure(:wrong_password_confirmation) { |data| render_json(422, user: data[:errors]) }
        .on_success { |result| render_json(201, user: result[:user]) }
        .on_unknown { raise NotImplementedError }
    end
  end
end
