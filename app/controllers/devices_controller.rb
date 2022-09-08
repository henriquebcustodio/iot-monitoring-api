class DevicesController < ApplicationController
  before_action :authenticate_user

  def create
    device_params = params.require(:device).permit(:name, :label, :description)

    input = {
      name: device_params[:name],
      label: device_params[:label],
      description: device_params[:description],
      user: current_user
    }

    ::Devices::Create
      .call(input)
      .on_failure(:blank_arguments) { |data| render_json(422, device: data[:errors]) }
      .on_failure(:validation_error) { |data| render_json(422, device: data[:errors]) }
      .on_success { |result| render_json(201, device: result[:device]) }
      .on_unknown { raise NotImplementedError }
  end
end
