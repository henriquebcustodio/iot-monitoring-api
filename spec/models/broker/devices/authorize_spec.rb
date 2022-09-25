require 'rails_helper'

RSpec.describe Broker::Devices::Authorize do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid token' do
        it 'returns a failure' do
          # given
          token = '1234567890'

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_failure
        end
      end
    end

    describe 'success' do
      context 'with a valid token' do
        let(:device) { create(:device) }

        it 'returns a success' do
          # given
          token = device.token

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the topic_id' do
          # given
          token = device.token

          # when
          result = described_class.call(token:)

          # then
          expect(result[:topic_id]).to eq(device.topic_id)
        end
      end
    end
  end
end
