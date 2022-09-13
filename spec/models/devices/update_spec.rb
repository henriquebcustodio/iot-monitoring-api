require 'rails_helper'

RSpec.describe Devices::Update do
  describe '.call' do
    describe 'failures' do
      context 'with a nonexistent device id' do
        let(:user) { create(:user) }
        let(:name) { 'sample' }
        let(:label) { 'sample' }
        let(:description) { 'sample' }

        it 'returns a failure' do
          # given
          id = [{}, [], 1].sample

          # when
          result = described_class.call(name:, description:, label:, id:, user_id: user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          id = [{}, [], nil].sample

          # when
          result = described_class.call(name:, description:, label:, id:, user_id: user.id)

          # then
          expect(result.type).to be(:not_found)
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end

      context 'with an invalid label' do
        let(:description) { 'sample' }
        let(:name) { 'sample' }
        let(:device) { create(:device) }

        it 'returns a failure' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: device.user_id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: device.user_id)

          # then
          expect(result.type).to be(:invalid_label)

          expect(result[:errors]).to include(
            label: 'must not include #, + or / characters'
          )
        end
      end

      context 'with an used device label' do
        let(:user) { create(:user) }
        let(:description) { 'sample' }
        let(:name) { 'sample' }

        it 'returns a failure' do
          # given
          first_device = create(:device, user:)
          second_device = create(:device, label: 'new-device', user:)
          label = first_device.label

          # when
          result = described_class.call(
            name:,
            description:,
            label:,
            id: second_device.id,
            user_id: second_device.user_id
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          first_device = create(:device, user:)
          second_device = create(:device, label: 'new-device', user:)
          label = first_device.label

          # when
          result = described_class.call(
            name:,
            description:,
            label:,
            id: second_device.id,
            user_id: second_device.user_id
          )

          # then
          expect(result.type).to be(:validation_error)
          expect(result[:errors]).to include(
            label: ['has already been taken']
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
          label = 'device label'

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: device.user_id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          name = 'device'
          description = 'device description'
          label = 'device label'

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: device.user_id)

          # then
          expect(result[:device]).to have_attributes(
            name:,
            description:,
            label:
          )
        end
      end

      context 'with blank arguments' do
        let(:device) do
          create(
            :device,
            name: 'device',
            description: 'description',
            label: 'label'
          )
        end

        it 'returns a success' do
          # given
          name = ''
          description = ''
          label = 'device-label'

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: device.user_id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          name = ''
          description = ''
          label = 'device-label'

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: device.user_id)

          # then
          expect(result[:device]).to have_attributes(
            name: 'device',
            description: 'description',
            label:
          )
        end
      end
    end
  end
end

