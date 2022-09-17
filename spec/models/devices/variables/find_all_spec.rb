require 'rails_helper'

RSpec.describe Devices::Variables::FindAll do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid device' do
        it 'returns a failure' do
          # given
          device = ['', [], {}].sample

          # when
          result = described_class.call(device:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          device = ['', [], {}].sample

          # when
          result = described_class.call(device:)

          # then
          expect(result.type).to be(:invalid_attributes)
        end
      end
    end

    describe 'success' do
      context 'with a valid device' do
        let(:device) { create(:device) }

        it 'returns a success' do
          # given
          create(:variable, label: 'variable1', device:)
          create(:variable, label: 'variable2', device:)

          # when
          result = described_class.call(device:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the devices' do
          # given
          variable1 = create(:variable, label: 'variable1', device:)
          variable2 = create(:variable, label: 'variable2', device:)

          # when
          result = described_class.call(device:)

          # then
          expect(result[:variables])
            .to match(
              [
                variable1,
                variable2
              ]
            )
        end
      end
    end
  end
end

