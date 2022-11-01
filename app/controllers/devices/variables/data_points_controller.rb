module Devices
  module Variables
    class DataPointsController < ApplicationController
      before_action :authenticate_user

      def index
        ::Devices::Variables::Find
          .call(id: params[:variable_id], user_id: current_user.id)
          .on_failure(:not_found) { |data| render_json(404, variable: data[:errors]) }
          .on_failure(:forbidden) { render_json(403) }
          .then(::Devices::Variables::DataPoints::FindAll)
          .on_success { |result| render_json(200, data_points: result[:data_points].as_json) }
          .on_unknown { raise NotImplementedError }
      end

      def create
        data_points_params = params.require(:data_point).permit(:timestamp, :value)

        creation_input = {
          timestamp: data_points_params[:timestamp],
          value: data_points_params[:value]
        }

        ::Devices::Variables::Find
          .call(id: params[:variable_id], user_id: current_user.id)
          .on_failure(:not_found) { |data| render_json(404, variable: data[:errors]) }
          .on_failure(:forbidden) { render_json(403) }
          .then(::Devices::Variables::DataPoints::Create, creation_input)
          .on_failure(:invalid_timestamp) { |data| render_json(422, data_point: data[:errors]) }
          .on_failure(:invalid_value_type) { |data| render_json(422, data_point: data[:errors]) }
          .on_failure(:validation_errors) { |data| render_json(422, data_point: data[:errors]) }
          .on_success { |result| render_json(201, data_point: result[:data_point].as_json) }
          .on_unknown { raise NotImplementedError }
      end

      def destroy
        input = {
          id: params[:id],
          user_id: current_user.id
        }

        ::Devices::Variables::DataPoints::Find
          .call(input)
          .on_failure(:not_found) { |data| render_json(404, data_point: data[:errors]) }
          .on_failure(:forbidden) { render_json(403) }
          .then(::Devices::Variables::DataPoints::Delete)
          .on_success { |result| render_json(200, data_point: result[:data_point]) }
          .on_unknown { raise NotImplementedError }
      end
    end
  end
end
