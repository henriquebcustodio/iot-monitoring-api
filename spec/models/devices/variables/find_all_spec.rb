require 'rails_helper'

RSpec.describe Devices::Variables::FindAll do
  describe '.call' do
    describe 'success' do
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

