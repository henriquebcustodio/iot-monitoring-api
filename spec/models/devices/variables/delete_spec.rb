require 'rails_helper'

RSpec.describe Devices::Variables::Delete do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid variable' do
        it 'returns a failure' do
          # given
          variable = ['', {}, []].sample

          # when
          result = described_class.call(variable:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          variable = ['', {}, []].sample

          # when
          result = described_class.call(variable:)

          # then
          expect(result.type).to be(:invalid_attributes)
        end
      end
    end

    describe 'success' do
      context 'with a valid variable' do
        it 'returns a success' do
          # given
          variable = create(:variable)

          # when
          result = described_class.call(variable:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes a confirmation message' do
          # given
          variable = create(:variable)

          # when
          result = described_class.call(variable:)

          # then
          expect(result[:variable]).to eq('successfully deleted')
        end

        it 'destroys the variable' do
          # given
          variable = create(:variable)

          # when
          described_class.call(variable:)

          # then
          expect(variable.destroyed?).to be(true)
        end
      end
    end
  end
end

