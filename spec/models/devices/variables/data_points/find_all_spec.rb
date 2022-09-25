require 'rails_helper'

RSpec.describe Devices::Variables::DataPoints::FindAll do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid variable' do
        it 'returns an error' do
          # given
          variable = ['', nil, {}].sample

          # when
          result = described_class.call(variable:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          variable = ['', nil, {}].sample

          # when
          result = described_class.call(variable:)

          # then
          expect(result.type).to be(:invalid_attributes)
          expect(result[:errors]).to include(:variable)
        end
      end
    end

    describe 'success' do
      context 'with a valid variable' do
        let(:variable) { create(:variable) }

        it 'returns a success' do
          # given
          create(:data_point, variable:)
          create(:data_point, variable:)

          # when
          result = described_class.call(variable:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the data points' do
          # given
          data_point1 = create(:data_point, variable:)
          data_point2 = create(:data_point, variable:)

          # when
          result = described_class.call(variable:)

          # then
          expect(result[:data_points])
            .to match(
              [
                data_point1,
                data_point2
              ]
            )
        end
      end
    end
  end
end
