require 'rails_helper'

RSpec.describe Devices::Variables::Find do
  describe '.call' do
    describe 'failures' do
      context "when the variable doesn't exist" do
        let(:device) { create(:device) }

        it 'returns a failure' do
          # given
          variable_id = 1

          # when
          result = described_class.call(id: variable_id, user_id: device.user_id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          variable_id = 1

          # when
          result = described_class.call(id: variable_id, user_id: device.user_id)

          # then
          expect(result.type).to be(:not_found)
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end

      context "when the variable doesn't belong to the user" do
        let(:variable) { create(:variable) }

        it 'returns a failure' do
          # given
          other_user = create(:user)

          # when
          result = described_class.call(id: variable.id, user_id: other_user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          other_user = create(:user)

          # when
          result = described_class.call(id: variable.id, user_id: other_user.id)

          # then
          expect(result.type).to be(:forbidden)
          expect(result[:errors]).to include(
            id: ['is not available to this user']
          )
        end
      end
    end

    describe 'success' do
      context 'with an existing variable' do
        let(:device) { create(:device) }

        it 'returns a success' do
          # given
          variable = create(:variable, device:)

          # when
          result = described_class.call(id: variable.id, user_id: device.user_id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          variable = create(:variable, device:)

          # when
          result = described_class.call(id: variable.id, user_id: device.user_id)

          # then
          expect(result[:variable]).to eq(variable)
        end
      end
    end
  end
end

