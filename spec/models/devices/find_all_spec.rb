require 'rails_helper'

RSpec.describe Devices::FindAll do
  describe '.call' do
    describe 'success' do
      let(:user) { create(:user) }

      it 'returns a success' do
        # given
        device1 = create(:device, label: 'device1', user:)
        device2 = create(:device, label: 'device2', user:)

        # when
        result = described_class.call(user_id: user.id)

        # then
        expect(result).to be_a_success
      end

      it 'exposes the devices' do
        # given
        device1 = create(:device, label: 'device1', user:)
        device2 = create(:device, label: 'device2', user:)

        # when
        result = described_class.call(user_id: user.id)

        # then
        expect(result[:devices])
          .to match(
            [
              device1,
              device2
            ]
          )
      end
    end
  end
end
