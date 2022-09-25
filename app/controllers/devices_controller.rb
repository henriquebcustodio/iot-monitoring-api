class DevicesController < ApplicationController
  before_action :authenticate_user

  def index
    input = {
      user_id: current_user.id
    }

    ::Devices::FindAll
      .call(input)
      .on_success { |result| render_json(200, devices: result[:devices]) }
  end

  def show
    input = {
      id: params[:id],
      user_id: current_user.id
    }

    ::Devices::Find
      .call(input)
      .on_failure(:not_found) { |data| render_json(404, device: data[:errors]) }
      .on_success { |result| render_json(200, device: result[:device]) }
      .on_unknown { raise NotImplementedError }
  end

  def create
    device_params = params.require(:device).permit(:name, :description)

    input = {
      name: device_params[:name],
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

  def update
    device_params = params.require(:device).permit(:name, :description)

    input = {
      name: device_params[:name],
      description: device_params[:description],
      id: params[:id],
      user_id: current_user.id
    }

    ::Devices::Update
      .call(input)
      .on_failure(:not_found) { |data| render_json(404, device: data[:errors]) }
      .on_failure(:validation_error) { |data| render_json(404, device: data[:errors]) }
      .on_success { |result| render_json(200, device: result[:device]) }
      .on_unknown { raise NotImplementedError }
  end

  def destroy
    input = {
      id: params[:id],
      user_id: current_user.id
    }

    ::Devices::Delete
      .call(input)
      .on_failure(:not_found) { |data| render_json(404, device: data[errors]) }
      .on_success { |result| render_json(200, device: result[:device]) }
      .on_unknown { raise NotImplementedError }
  end
end
