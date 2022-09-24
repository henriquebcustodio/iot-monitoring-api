require 'rails_helper'

RSpec.describe Devices::Variables::DataPoints::Create do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid timestamp' do
        let(:variable) { create(:variable, variable_type: 'numeric') }
        let(:value) { rand(30) }

        context 'with an invalid type' do
          it 'returns a failure' do
            # given
            timestamp = ['', {}, []].sample

            # when
            result = described_class.call(variable:, value:, timestamp:)

            # then
            expect(result).to be_a_failure
          end

          it 'exposes the error' do
            # given
            timestamp = ['', {}, []].sample

            # when
            result = described_class.call(variable:, value:, timestamp:)

            # then
            expect(result.type).to eq(:invalid_attributes)
            expect(result[:errors].details).to include(:timestamp)
          end
        end

        context 'when it is not in milliseconds' do
          it 'returns a failure' do
            # given
            timestamp = Time.now.to_i

            # when
            result = described_class.call(variable:, value:, timestamp:)

            # then
            expect(result).to be_a_failure
          end

          it 'exposes the error' do
            # given
            timestamp = Time.now.to_i

            # when
            result = described_class.call(variable:, value:, timestamp:)

            # then
            expect(result.type).to eq(:invalid_timestamp)
            expect(result[:errors]).to match(
              timestamp: ['must be in milliseconds']
            )
          end
        end

        context 'when it is not a positive number' do
          it 'returns a failure' do
            # given
            timestamp = -1234567890123

            # when
            result = described_class.call(variable:, value:, timestamp:)

            # then
            expect(result).to be_a_failure
          end

          it 'exposes the error' do
            # given
            timestamp = -1234567890123

            # when
            result = described_class.call(variable:, value:, timestamp:)

            # then
            expect(result.type).to eq(:invalid_timestamp)
            expect(result[:errors]).to match(
              timestamp: ['must be a positive number']
            )
          end
        end
      end

      context "when the value doesn't match the variable type" do
        context 'and the variable has a numeric type' do
          it 'returns an error' do
            # given
            variable = create(:variable, variable_type: 'numeric')
            value = [true, false, 'invalid'].sample

            # when
            result = described_class.call(variable:, value:)

            # then
            expect(result).to be_a_failure
          end

          it 'exposes the error' do
            # given
            variable = create(:variable, variable_type: 'numeric')
            value = [true, false, 'invalid'].sample

            # when
            result = described_class.call(variable:, value:)

            # then
            expect(result.type).to be(:invalid_value_type)
            expect(result[:errors]).to include(
              value: 'must be numeric'
            )
          end
        end

        context 'and the variable has a boolean type' do
          it 'returns an error' do
            # given
            variable = create(:variable, variable_type: 'boolean')
            value = ['invalid', 1, 44.5].sample

            # when
            result = described_class.call(variable:, value:)

            # then
            expect(result).to be_a_failure
          end

          it 'exposes the error' do
            # given
            variable = create(:variable, variable_type: 'boolean')
            value = ['invalid', 1, 44.5].sample

            # when
            result = described_class.call(variable:, value:)

            # then
            expect(result.type).to be(:invalid_value_type)
            expect(result[:errors]).to include(
              value: 'must be boolean'
            )
          end
        end

        context 'and the variable has a text type' do
          it 'returns an error' do
            # given
            variable = create(:variable, variable_type: 'text')
            value = [1, 33.5, true, false].sample

            # when
            result = described_class.call(variable:, value:)

            # then
            expect(result).to be_a_failure
          end

          it 'exposes the error' do
            # given
            variable = create(:variable, variable_type: 'text')
            value = [1, 33.5, true, false].sample

            # when
            result = described_class.call(variable:, value:)

            # then
            expect(result.type).to be(:invalid_value_type)
            expect(result[:errors]).to include(
              value: 'must be a string'
            )
          end
        end

      end
    end

    describe 'success' do
      context 'with a timestamp' do
        it 'returns a success' do
          # given
          variable = create(:variable, variable_type: 'numeric')
          timestamp = (Time.now.to_f * 1000).to_i
          value = rand(30)

          # when
          result = described_class.call(variable:, value:, timestamp:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the data point' do
          # given
          variable = create(:variable, variable_type: 'numeric')
          timestamp = (Time.now.to_f * 1000).to_i
          value = rand(30).to_f

          # when
          result = described_class.call(variable:, value:, timestamp:)

          # then
          expect(result[:data_point]).to be_a(DataPoint)
          expect(result[:data_point]).to have_attributes(
            numeric_value: value,
            timestamp: Time.strptime(timestamp.to_s, '%Q')
          )
        end
      end

      context 'without a timestamp' do
        it 'returns a success' do
          # given
          variable = create(:variable, variable_type: 'numeric')
          value = rand(30)

          # when
          result = described_class.call(variable:, value:)

          # then
          expect(result).to be_a_success
        end

        it 'sets the timestamp' do
          # given
          variable = create(:variable, variable_type: 'numeric')
          value = rand(30)

          # when
          result = described_class.call(variable:, value:)

          # then
          timestamp = result[:data_point][:timestamp]
          expect(timestamp).to be_a(Time)
        end
      end

      context 'with a numeric variable' do
        it 'sets the numeric value' do
          # given
          variable = create(:variable, variable_type: 'numeric')
          value = rand(30)

          # when
          result = described_class.call(variable:, value:)

          # then
          expect(result[:data_point].numeric_value).to eq(value)
        end
      end

      context 'with a boolean variable' do
        it 'sets the boolean value' do
          # given
          variable = create(:variable, variable_type: 'boolean')
          value = [true, false].sample

          # when
          result = described_class.call(variable:, value:)

          # then
          expect(result[:data_point].bool_value).to eq(value)
        end
      end

      context 'with a text variable' do
        it 'sets the text value' do
          # given
          variable = create(:variable, variable_type: 'text')
          value = 'starting sensor'

          # when
          result = described_class.call(variable:, value:)

          # then
          expect(result[:data_point].text_value).to eq(value)
        end
      end
    end
  end
end
