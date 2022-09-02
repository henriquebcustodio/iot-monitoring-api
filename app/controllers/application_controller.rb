class ApplicationController < ActionController::API
  def render_json(status, json = {})
    render status:, json:
  end
end
