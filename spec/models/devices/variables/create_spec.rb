require 'rails_helper'

RSpec.describe Devices::Variables::Create do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid variable type' do
        let(:name) { ::Faker::Hacker.abbreviation }
        let(:label) { ::Faker::Device.name }
        let(:description) { ::Faker::Hacker.say_something_smart }
        let(:device) { create(:device) }

        it 'returns a failure' do
          # given
          type = [{}, 'invalid', []].sample

          # when
          result = described_class.call(name:, label:, description:, type:, device_id: device.id, 
                                        user_id: device.user_id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          type = [{}, 'invalid', []].sample

          # when
          result = described_class.call(name:, label:, description:, type:, device_id: device.id, 
                                        user_id: device.user_id)

          # then
          expect(result.type).to be(:invalid_type)
          expect(result[:errors]).to include(
            type: 'should be boolean, numeric or text'
          )
        end
      end

      context "when the device doesn't exist" do
        let(:name) { ::Faker::Hacker.abbreviation }
        let(:label) { ::Faker::Device.name }
        let(:description) { ::Faker::Hacker.say_something_smart }
        let(:type) { 'boolean' }
        let(:user) { create(:user) }

        it 'returns a failure' do
          # given
          device_id = 2

          # when
          result = described_class.call(name:, label:, description:, type:, device_id:, user_id: user.id)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          device_id = 2

          # when
          result = described_class.call(name:, label:, description:, type:, device_id:, user_id: user.id)

          # then
          expect(result.type).to be(:device_not_found)
          expect(result[:errors]).to include(
            id: 'not found'
          )
        end
      end
      
      context 'with an used variable label' do
        let(:name) { ::Faker::Hacker.abbreviation }
        let(:description) { ::Faker::Hacker.say_something_smart }
        let(:type) { %w[boolean numeric text].sample }
        let(:device) { create(:device) }

        it 'returns a failure' do
          # given
          variable = create(:variable, label: 'label')

          # when
          result = described_class.call(
            name:,
            label: variable.label,
            description:,
            type:,
            device_id: device.id,
            user_id: device.user_id
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          variable = create(:variable, label: 'label')

          # when
          result = described_class.call(
            name:,
            label: variable.label,
            description:,
            type:,
            device_id: device.id,
            user_id: device.user_id
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
      context 'with valid arguments' do
        it 'returns a success' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ::Faker::Hacker.say_something_smart
          label = ::Faker::Device.model_name
          type = %w[boolean numeric text].sample
          device = create(:device)

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device_id: device.id,
            user_id: device.user_id
          )

          # then
          expect(result).to be_a_success
        end

        it 'exposes the variable' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ::Faker::Hacker.say_something_smart
          label = ::Faker::Device.model_name
          type = %w[boolean numeric text].sample
          device = create(:device)

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device_id: device.id,
            user_id: device.user_id
          )

          # then
          expect(result[:variable]).to be_a(Variable)
          expect(result[:variable]).to have_attributes(
            name:,
            description:,
            label:,
            variable_type: type,
            device:
          )
        end
      end
    end
  end
end