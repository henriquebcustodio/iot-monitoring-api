require 'rails_helper'

RSpec.describe Devices::Variables::Update do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid variable' do
        it 'returns a failure' do
          # given
          variable = ['', [], {}].sample

          # when
          result = described_class.call(variable:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          variable = ['', [], {}].sample

          # when
          result = described_class.call(variable:)

          # then
          expect(result.type).to be(:invalid_attributes)
        end
      end

      context 'with an invalid label' do
        let(:variable) { create(:variable) }

        it 'returns a failure' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(variable:, label:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          label = %w[name# /wrong +invalid].sample

          # when
          result = described_class.call(variable:, label:)

          # then
          expect(result.type).to be(:invalid_label)

          expect(result[:errors]).to include(
            label: 'must not include #, + or / characters'
          )
        end
      end

      context 'with an invalid variable type' do
        let(:variable) { create(:variable) }

        it 'returns a failure' do
          # given
          type = [{}, 'invalid', []].sample

          # when
          result = described_class.call(
            variable:,
            type:
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          type = [{}, 'invalid', []].sample

          # when
          result = described_class.call(
            variable:,
            type:
          )

          # then
          expect(result.type).to be(:invalid_type)
          expect(result[:errors]).to include(
            type: 'should be boolean, numeric or text'
          )
        end
      end

      context 'with an used label' do
        it 'returns a failure' do
          # given
          variable1 = create(:variable, label: 'label')
          variable2 = create(:variable)
          used_label = variable1.label

          # when
          result = described_class.call(
            variable: variable2,
            label: used_label
          )

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          variable1 = create(:variable, label: 'label')
          variable2 = create(:variable)
          used_label = variable1.label

          # when
          result = described_class.call(
            variable: variable2,
            label: used_label
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
        let(:variable) { create(:variable) }

        it 'returns a success' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ::Faker::Hacker.say_something_smart
          label = 'my-variable'
          type = %w[boolean numeric text].sample

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            variable:
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

          # when
          result = described_class.call(
            name:,
            label:,
            description:,
            type:,
            variable:
          )

          # then
          expect(result[:variable]).to be_a(Variable)
          expect(result[:variable]).to have_attributes(
            name:,
            description:,
            label:,
            variable_type: type
          )
        end
      end

      context 'with only some arguments' do
        let(:variable) { create(:variable) }

        it 'returns a success' do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ''

          # when
          result = described_class.call(
            name:,
            description:,
            variable:
          )

          # then
          expect(result).to be_a_success
        end

        it "doesn't change the other attributes" do
          # given
          name = ::Faker::Hacker.abbreviation
          description = ''

          old_label = variable.label
          old_type = variable.variable_type

          # when
          result = described_class.call(
            name:,
            description:,
            variable:
          )

          # then
          expect(result[:variable]).to be_a(Variable)
          expect(result[:variable]).to have_attributes(
            name:,
            description:,
            label: old_label,
            variable_type: old_type
          )
        end
      end
    end
  end
end
