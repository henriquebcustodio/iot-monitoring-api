require 'rails_helper'

RSpec.describe Devices::Create do
  describe '.call' do
    describe 'failures' do
      context 'with blank arguments' do
        let(:description) { 'sample' }
        let(:user) { create(:user) }

        it 'returns a failure' do
          # given
          name = ['', ' ', nil].sample

          # when
          result = described_class.call(name:, description:, user:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          name = ['', ' ', nil].sample

          # when
          result = described_class.call(name:, description:, user:)

          # then
          expect(result.type).to be(:blank_arguments)

          expect(result[:errors]).to include(
            name: ["can't be blank"]
          )
        end
      end

      context 'with an invalid user' do
        let(:name) { 'sample' }
        let(:description) { 'sample' }

        it 'returns a failure' do
          # given
          user = [{}, [], nil].sample

          # when
          result = described_class.call(name:, description:, user:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          user = [{}, [], nil].sample

          # when
          result = described_class.call(name:, description:, user:)

          # then
          expect(result.type).to be(:invalid_attributes)
        end
      end
    end

    describe 'success' do
      context 'with valid arguments' do
        it 'returns a success' do
          # given
          name = 'device'
          description = 'device description'
          user = create(:user)

          # when
          result = described_class.call(name:, description:, user:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          name = 'device'
          description = 'device description'
          user = create(:user)

          # when
          result = described_class.call(name:, description:, user:)

          # then
          expect(result[:device]).to be_a(Device)
          expect(result[:device]).to have_attributes(
            name:,
            description:,
            user_id: user.id
          )
        end

        it 'generates a token' do
          # given
          name = 'device'
          description = 'device description'
          user = create(:user)

          # when
          result = described_class.call(name:, description:, user:)

          # then
          token = result[:device]['token']
          expect(token).to be_a(String)
          expect(token.length).to eq(36)
        end

        it 'generates a topic id' do
          # given
          name = 'device'
          description = 'device description'
          user = create(:user)

          # when
          result = described_class.call(name:, description:, user:)

          # then
          topic_id = result[:device]['topic_id']
          expect(topic_id).to be_a(String)
          expect(topic_id.length).to eq(20)
        end
      end
    end
  end
end
