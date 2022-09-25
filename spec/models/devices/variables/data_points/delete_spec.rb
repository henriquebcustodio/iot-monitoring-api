require 'rails_helper'

RSpec.describe Devices::Variables::DataPoints::Delete do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid data point' do
        it 'returns a failure' do
          # given
          data_point = ['', {}, []].sample

          # when
          result = described_class.call(data_point:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          data_point = ['', {}, []].sample

          # when
          result = described_class.call(data_point:)

          # then
          expect(result.type).to be(:invalid_attributes)
          expect(result[:errors]).to include(:data_point)
        end
      end
    end

    describe 'success' do
      context 'with a valid data point' do
        it 'returns a success' do
          # given
          data_point = create(:data_point)

          # when
          result = described_class.call(data_point:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes a confirmation message' do
          # given
          data_point = create(:data_point)

          # when
          result = described_class.call(data_point:)

          # then
          expect(result[:data_point]).to eq('successfully deleted')
        end

        it 'destroys the data point' do
          # given
          data_point = create(:data_point)

          # when
          described_class.call(data_point:)

          # then
          expect(data_point.destroyed?).to be(true)
        end
      end
    end
  end
end


