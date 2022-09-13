require 'rails_helper'

RSpec.describe Devices::Find do
  describe '.call' do
    describe 'failures' do
      context "when the device doesn't exist" do
        it 'returns a failure' do
          # given
          user_id = 1
          device_id = 1

          # when
          result = described_class.call(id: device_id, user_id:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          user_id = 1
          device_id = 1

          # when
          result = described_class.call(id: device_id, user_id:)

          # then
          expect(result.type).to be(:not_found)
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end
    end

    describe 'success' do
      context 'with an existing device' do
        it 'returns a success' do
          # given
          device = create(:device)

          # when
          result = described_class.call(id: device.id, user_id: device.user_id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          device = create(:device)

          # when
          result = described_class.call(id: device.id, user_id: device.user_id)

          # then
          expect(result[:device]).to eq(device)
        end
      end
    end
  end
end
