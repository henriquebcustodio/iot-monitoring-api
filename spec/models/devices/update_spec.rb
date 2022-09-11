require 'rails_helper'

RSpec.describe Devices::Update do
  def create_user
    User.create(
      email: 'henrique@gmail.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  describe '.call' do
    describe 'failures' do
      context 'with a nonexistent device id' do
        let(:user) { create_user }
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
        let(:user) { create_user }
        let(:description) { 'sample' }
        let(:name) { 'sample' }
        let(:device) do
          Device.create(
            name: 'sample',
            label: 'sample',
            description: 'sample',
            user:
          )
        end

        it 'returns a failure' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: user.id)

          # then
          expect(result.type).to be(:invalid_label)

          expect(result[:errors]).to include(
            label: 'must not include #, + or / characters'
          )
        end
      end

      context 'with an used device label' do
        let(:user) { create_user }
        let(:description) { 'sample' }
        let(:name) { 'sample' }
        let(:device) do
          Device.create(
            name: 'sample',
            label: 'sample',
            description: 'sample',
            user:
          )
        end

        it 'returns a failure' do
          # given
          label = device.label
          new_device = Device.create(
            name: 'sample',
            label: 'new-device',
            description: 'sample',
            user:
          )

          # when
          result = described_class.call(name:, description:, label:, id: new_device.id, user_id: user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          label = device.label
          new_device = Device.create(
            name: 'sample',
            label: 'new-device',
            description: 'sample',
            user:
          )

          # when
          result = described_class.call(name:, description:, label:, id: new_device.id, user_id: user.id)

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
        let(:user) { create_user }
        let(:name) { 'device' }
        let(:description) { 'device description' }
        let(:label) { 'device-label' }
        let(:device) do
          Device.create(
            name: 'sample',
            description: 'sample',
            label: 'sample',
            user:
          )
        end

        it 'returns a success' do
          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: user.id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: user.id)

          # then
          expect(result[:device]).to include(
            'name' => name,
            'description' => description,
            'label' => label
          )
        end
      end

      context 'with blank arguments' do
        let(:user) { create_user }
        let(:name) { '' }
        let(:description) { '' }
        let(:label) { 'device-label' }
        let(:device) do
          Device.create(
            name: 'sample',
            description: 'sample',
            label: 'sample',
            user:
          )
        end

        it 'returns a success' do
          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: user.id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # when
          result = described_class.call(name:, description:, label:, id: device.id, user_id: user.id)

          # then
          expect(result[:device]).to include(
            'name' => 'sample',
            'description' => 'sample',
            'label' => label
          )
        end
      end
    end
  end
end

