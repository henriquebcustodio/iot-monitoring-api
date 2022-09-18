require 'rails_helper'

RSpec.describe Devices::Variables::Create do
  describe '.call' do
    describe 'failures' do
      context 'with blank arguments' do
        let(:description) { ::Faker::Hacker.say_something_smart }
        let(:device) { create(:device) }
        let(:type) { 'boolean' }

        it 'returns a failure' do
          # given
          name = ['', ' ', nil].sample
          label = ['', ' ', nil].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          name = ['', ' '].sample
          label = ['', ' '].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result.type).to be(:blank_arguments)
          expect(result[:errors]).to include(
            name: ["can't be blank"],
            label: ["can't be blank"]
          )
        end
      end

      context 'with an invalid label' do
        let(:name) { ::Faker::Hacker.abbreviation }
        let(:label) { ::Faker::Device.name }
        let(:description) { ::Faker::Hacker.say_something_smart }
        let(:device) { create(:device) }
        let(:type) { 'numeric' }

        it 'returns a failure' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result.type).to be(:invalid_label)

          expect(result[:errors]).to include(
            label: 'must not include #, + or / characters'
          )
        end
      end

      context 'with an invalid variable type' do
        let(:name) { ::Faker::Hacker.abbreviation }
        let(:label) { ::Faker::Device.name }
        let(:description) { ::Faker::Hacker.say_something_smart }
        let(:device) { create(:device) }

        it 'returns a failure' do
          # given
          type = [{}, 'invalid', []].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          type = [{}, 'invalid', []].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result.type).to be(:invalid_type)
          expect(result[:errors]).to include(
            type: 'should be boolean, numeric or text'
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
            device:
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
            device:
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
      context 'with all arguments' do
        it 'returns a success' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ::Faker::Hacker.say_something_smart
          label = 'my-variable'
          type = %w[boolean numeric text].sample
          device = create(:device)

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result).to be_a_success
        end

        it 'exposes the variable' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ::Faker::Hacker.say_something_smart
          label = 'my-variable'
          type = %w[boolean numeric text].sample
          device = create(:device)

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
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

      context 'without a description' do
        it 'returns a success' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = nil
          label = 'my-variable'
          type = %w[boolean numeric text].sample
          device = create(:device)

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result).to be_a_success
        end

        it 'sets the description to ""' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = nil
          label = 'my-variable'
          type = %w[boolean numeric text].sample
          device = create(:device)

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            device:
          )

          # then
          expect(result[:variable]).to be_a(Variable)
          expect(result[:variable]).to have_attributes(
            name:,
            description: '',
            label:,
            variable_type: type,
            device:
          )
        end
      end
    end
  end
end
