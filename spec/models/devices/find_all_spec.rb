require 'rails_helper'

RSpec.describe Devices::FindAll do
  def create_user
    User.create(
      email: 'henrique@gmail.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  describe '.call' do
    describe 'success' do
      let(:user) { create_user }

      it 'returns a success' do
        # given
        device1 = Device.create(
          name: 'sample',
          label: 'device1',
          user:
        )
        device2 = Device.create(
          name: 'sample',
          label: 'device2',
          user:
        )

        # when
        result = described_class.call(user_id: user.id)

        # then
        expect(result).to be_a_success
      end

      it 'exposes the devices' do
        # given
        device1 = Device.create(
          name: 'sample',
          label: 'device1',
          user:
        )
        device2 = Device.create(
          name: 'sample',
          label: 'device2',
          user:
        )

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
