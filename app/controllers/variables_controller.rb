class VariablesController < ApplicationController
  before_action :authenticate_user

  def index
    ::Devices::Find
      .call(id: params[:device_id], user_id: current_user.id)
      .on_failure(:not_found) { |data| render_json(404, device: data[:errors]) }
      .then(::Devices::Variables::FindAll)
      .on_success { |result| render_json(200, variables: result[:variables]) }
      .on_unknown { raise NotImplementedError }
  end

  def show
    input = {
      id: params[:id],
      user_id: current_user.id
    }

    ::Devices::Variables::Find
      .call(input)
      .on_failure(:not_found) { |data| render_json(404, variable: data[:errors]) }
      .on_failure(:forbidden) { render_json(403) }
      .on_success { |result| render_json(200, variable: result[:variable]) }
      .on_unknown { raise NotImplementedError }
  end

  def create
    variable_params = params.require(:variable).permit(:name, :label, :description, :type)

    creation_input = {
      name: variable_params[:name],
      label: variable_params[:label],
      description: variable_params[:description],
      type: variable_params[:type]
    }

    ::Devices::Find
      .call(id: params[:device_id], user_id: current_user.id)
      .on_failure(:not_found) { |data| render_json(404, device: data[:errors]) }
      .then(::Devices::Variables::Create, creation_input)
      .on_failure(:blank_arguments) { |data| render_json(422, variable: data[:errors]) }
      .on_failure(:invalid_label) { |data| render_json(422, variable: data[:errors]) }
      .on_failure(:invalid_type) { |data| render_json(422, variable: data[:errors]) }
      .on_failure(:validation_error) { |data| render_json(422, variable: data[:errors]) }
      .on_success { |result| render_json(201, variable: result[:variable]) }
      .on_unknown { raise NotImplementedError }
  end

  def update
    variable_params = params.require(:variable).permit(:name, :label, :description, :type)

    update_input = {
      name: variable_params[:name],
      label: variable_params[:label],
      description: variable_params[:description],
      type: variable_params[:type]
    }

    ::Devices::Variables::Find
      .call(id: params[:id], user_id: current_user.id)
      .on_failure(:not_found) { |data| render_json(404, variable: data[:errors]) }
      .on_failure(:forbidden) { render_json(403) }
      .then(::Devices::Variables::Update, update_input)
      .on_failure(:invalid_label) { |data| render_json(422, variable: data[:errors]) }
      .on_failure(:invalid_type) { |data| render_json(422, variable: data[:errors]) }
      .on_failure(:validation_error) { |data| render_json(422, variable: data[:errors]) }
      .on_success { |result| render_json(200, variable: result[:variable]) }
      .on_unknown { raise NotImplementedError }
  end

  def destroy
    input = {
      id: params[:id],
      user_id: current_user.id
    }

    ::Devices::Variables::Find
      .call(input)
      .on_failure(:not_found) { |data| render_json(404, variable: data[:errors]) }
      .on_failure(:forbidden) { render_json(403) }
      .then(::Devices::Variables::Delete)
      .on_success { |result| render_json(200, variable: result[:variable]) }
      .on_unknown { raise NotImplementedError }
  end
end
