require 'rails_helper'

RSpec.describe Broker::Messages::Process do
  describe '.call' do
    let(:device) { create(:device) }
    let(:topic) { "/devices/#{device.topic_id}" }
    let(:timestamp) { ::DateTime.now.strftime('%Q').to_i }
    let(:formatted_timestamp) { ::Time.strptime(timestamp.to_s, '%Q').utc }

    describe 'failures' do
      context 'with invalid attribute types' do
        context 'with an invalid topic' do
          it 'returns a failure' do
            # given
            topic = [nil, [], Object.new].sample
            message = { 'label' => 'temperature', 'value' => 10, 'timestamp' => timestamp }

            # when
            result = described_class.call(topic:, message:)

            # then
            expect(result).to be_a_failure
            expect(result.type).to be(:invalid_attributes)
            expect(result.data.keys).to contain_exactly(:errors)
            expect(result[:errors]).to include(:topic)
          end
        end

        context 'with an invalid message' do
          it 'returns a failure' do
            # given
            message = [nil, [], Object.new].sample

            # when
            result = described_class.call(topic:, message:)

            # then
            expect(result).to be_a_failure
            expect(result.type).to be(:invalid_attributes)
            expect(result.data.keys).to contain_exactly(:errors)
            expect(result[:errors]).to include(:message)
          end
        end
      end

      context 'with an invalid topic' do
        it 'returns a failure' do
          # given
          variable = create(:variable, device:, variable_type: 'numeric')
          message = { 'label' => variable.label, 'value' => 10, 'timestamp' => timestamp }
          topic = '/devices/invalid'

          # when
          result = described_class.call(topic:, message:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:device_not_found)
          expect(result.data).to eq(device_not_found: true)
        end

      end

      context "when the variable doesn't exist" do
        it 'returns a failure' do
          # given
          message = { 'label' => 'temperature', 'value' => 10, 'timestamp' => timestamp }

          # when
          result = described_class.call(topic:, message:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:variable_not_found)
          expect(result.data).to eq(variable_not_found: true)
        end
      end

      context 'with an invalid message' do
        it 'returns a failure' do
          # given
          variable = create(:variable, device:, variable_type: 'numeric')
          message = { 'label' => variable.label, 'wrong' => 5, 'timestamp' => timestamp }

          # when
          result = described_class.call(topic:, message:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:invalid_data_point)
          expect(result.data).to eq(invalid_data_point: true)
        end
      end
    end

    describe 'success' do
      context 'with a valid data point' do
        it 'returns a success' do
          # given
          variable = create(:variable, device:, variable_type: 'numeric')
          message = { 'label' => variable.label, 'value' => 10, 'timestamp' => timestamp }

          # when
          result = described_class.call(topic:, message:)

          # then
          expect(result).to be_a_success
          expect(result.type).to be(:message_processed)
          expect(result.data).to eq(message_processed: true)
        end

        it 'pushes the data point to the batch writer' do
          # given
          allow(::Devices::Variables::DataPoints::BatchWriter.instance)
            .to receive(:push)
            .and_call_original

          variable = create(:variable, device:, variable_type: 'numeric')
          message = { 'label' => variable.label, 'value' => 10, 'timestamp' => timestamp }

          # when
          described_class.call(topic:, message:)

          # then
          expect(::Devices::Variables::DataPoints::BatchWriter.instance)
            .to have_received(:push)
            .with({ numeric_value: 10, timestamp: formatted_timestamp, variable_id: variable.id })
        end

        it 'broadcasts the data point via action cable' do
          # given
          variable = create(:variable, device:, variable_type: 'numeric')
          message = { 'label' => variable.label, 'value' => 10, 'timestamp' => timestamp }

          # when / then
          expect { described_class.call(topic:, message:) }
            .to have_broadcasted_to("variable_#{variable.id}")
            .with({ timestamp: formatted_timestamp, value: 10 })
        end
      end
    end
  end
end
