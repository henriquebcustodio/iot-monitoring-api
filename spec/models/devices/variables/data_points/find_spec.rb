require 'rails_helper'

RSpec.describe Devices::Variables::DataPoints::Find do
  describe '.call' do
    describe 'failures' do
      context "when the data_point doesn't exist" do
        let(:variable) { create(:variable) }

        it 'returns a failure' do
          # given
          data_point_id = 1

          # when
          result = described_class.call(id: data_point_id, user_id: variable.user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          data_point_id = 1

          # when
          result = described_class.call(id: data_point_id, user_id: variable.user.id)

          # then
          expect(result.type).to be(:not_found)
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end

      context "when the data point doesn't belong to the user" do
        let(:data_point) { create(:data_point) }

        it 'returns a failure' do
          # given
          other_user = create(:user)

          # when
          result = described_class.call(id: data_point.id, user_id: other_user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          other_user = create(:user)

          # when
          result = described_class.call(id: data_point.id, user_id: other_user.id)

          # then
          expect(result.type).to be(:forbidden)
          expect(result[:errors]).to include(
            id: ['is not available to this user']
          )
        end
      end
    end

    describe 'success' do
      context 'with an existing data point' do
        let(:variable) { create(:variable, variable_type: 'numeric') }

        it 'returns a success' do
          # given
          data_point = create(:data_point, variable:)

          # when
          result = described_class.call(id: data_point.id, user_id: variable.user.id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the data point' do
          # given
          data_point = create(:data_point, variable:)

          # when
          result = described_class.call(id: data_point.id, user_id: variable.user.id)

          # then
          expect(result[:data_point]).to eq(data_point)
        end
      end
    end
  end
end


