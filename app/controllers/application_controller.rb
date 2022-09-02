class ApplicationController < ActionController::API
  attr_reader :current_user

  rescue_from ActionController::ParameterMissing, with: :show_parameter_missing_error

  def authenticate_user
    token = request.headers['Authorization'].split(' ').last

    ::Users::Authenticate
      .call(token:)
      .on_failure { |result| render_json(401, user: result[:errors]) }
      .on_success do |result|
        token_payload = result[:token_payload]
        @current_user = User.find_by_id(token_payload['id'])
      end
  end

  def render_json(status, json = {})
    render status:, json:
  end

  def show_parameter_missing_error(exception)
    render_json(400, error: exception.message)
  end
end
