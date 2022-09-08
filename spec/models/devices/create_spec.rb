require 'rails_helper'

RSpec.describe Devices::Create do
  def create_user
    User.create(
      email: 'henrique@gmail.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  describe '.call' do
    describe 'failures' do
      context 'with blank arguments' do
        let(:description) { 'sample' }
        let(:user) { create_user }

        it 'returns a failure' do
          # given
          name = ['', ' ', nil].sample
          label = ['', ' ', nil].sample

          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          name = ['', ' ', nil].sample
          label = ['', ' ', nil].sample

          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result.type).to be(:blank_arguments)

          expect(result[:errors]).to include(
            name: ["can't be blank"],
            label: ["can't be blank"]
          )
        end
      end

      context 'with an invalid user' do
        let(:name) { 'sample' }
        let(:label) { 'sample' }
        let(:description) { 'sample' }

        it 'returns a failure' do
          # given
          user = [{}, [], nil].sample

          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          user = [{}, [], nil].sample

          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result.type).to be(:invalid_attributes)
        end
      end

      context 'with an used device label' do
        let(:device) do
          Device.create(
            name: 'sample',
            label: 'sample',
            description: 'sample',
            user:
          )
        end

        let(:description) { 'sample' }
        let(:name) { 'sample' }
        let(:user) { create_user }

        it 'returns a failure' do
          # given
          label = device.label

          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          label = device.label

          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result.type).to be(:validation_error)
          expect(result[:errors]).to include(
            label: ['has already been taken']
          )
        end
      end
    end

    describe 'success' do
      context 'with valid arguments' do
        let(:name) { 'device' }
        let(:description) { 'device description' }
        let(:label) { 'device-label' }
        let(:user) { create_user }

        it 'returns a success' do
          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          expect(result[:device]).to include(
            'name' => name,
            'description' => description,
            'label' => label,
            'user_id' => user.id
          )
        end

        it 'generates a token' do
          # when
          result = described_class.call(name:, description:, label:, user:)

          # then
          token = result[:device]['token']
          expect(token).to be_a(String)
          expect(token.length).to eq(36)
        end
      end
    end
  end
end
