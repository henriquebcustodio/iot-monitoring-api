require 'rails_helper'

RSpec.describe Devices::Update do
  describe '.call' do
    describe 'failures' do
      context 'with a nonexistent device id' do
        let(:user) { create(:user) }
        let(:name) { 'sample' }
        let(:description) { 'sample' }

        it 'returns a failure' do
          # given
          id = [{}, [], 1].sample

          # when
          result = described_class.call(name:, description:, id:, user_id: user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          id = [{}, [], nil].sample

          # when
          result = described_class.call(name:, description:, id:, user_id: user.id)

          # then
          expect(result.type).to be(:not_found)
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end
    end

    describe 'success' do
      context 'without blank arguments' do
        let(:device) { create(:device) }

        it 'returns a success' do
          # given
          name = 'device'
          description = 'device description'

          # when
          result = described_class.call(name:, description:, id: device.id, user_id: device.user_id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          name = 'device'
          description = 'device description'

          # when
          result = described_class.call(name:, description:, id: device.id, user_id: device.user_id)

          # then
          expect(result[:device]).to have_attributes(
            name:,
            description:
          )
        end
      end

      context 'with blank arguments' do
        let(:device) do
          create(
            :device,
            name: 'device',
            description: 'description'
          )
        end

        it 'returns a success' do
          # given
          name = ''
          description = ''

          # when
          result = described_class.call(name:, description:, id: device.id, user_id: device.user_id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          name = ''
          description = ''

          # when
          result = described_class.call(name:, description:, id: device.id, user_id: device.user_id)

          # then
          expect(result[:device]).to have_attributes(
            name:,
            description:
          )
        end
      end
    end
  end
end

