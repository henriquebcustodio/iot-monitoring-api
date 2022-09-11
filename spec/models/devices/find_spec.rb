RSpec.describe Devices::Find do
  def create_user
    User.create(
      email: 'henrique@gmail.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  def create_device(user)
    Device.create(
      name: 'sample',
      label: 'sample',
      description: 'sample',
      user:
    )
  end

  describe '.call' do
    describe 'failures' do
      context "when the device doesn't exist" do
        it 'returns a failure' do
          # given
          user_id = 1
          device_id = 1

          # when
          result = described_class.call(id: device_id, user_id:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          user_id = 1
          device_id = 1

          # when
          result = described_class.call(id: device_id, user_id:)

          # then
          expect(result.type).to be(:not_found)
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end
    end

    describe 'success' do
      context 'with an existing device' do
        it 'returns a success' do
          # given
          user = create_user
          device = create_device(user)

          # when
          result = described_class.call(id: device.id, user_id: user.id)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the device' do
          # given
          user = create_user
          device = create_device(user)

          # when
          result = described_class.call(id: device.id, user_id: user.id)

          # then
          expect(result[:device]).to include(
            'id' => device.id,
            'name' => device.name,
            'label' => device.name,
            'description' => device.description
          )
        end
      end
    end
  end
end
