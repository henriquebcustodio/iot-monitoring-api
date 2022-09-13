require 'rails_helper'

RSpec.describe Users::Login do
  describe '.call' do
    describe 'failures' do
      context "when user doesn't exist" do
        it 'returns a failure' do
          # given
          password = 'password'
          email = 'henrique@gmail.com'

          # when
          result = described_class.call(email:, password:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          password = 'password'
          email = 'henrique@gmail.com'

          # when
          result = described_class.call(email:, password:)

          # then
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end

      context 'with an invalid password' do
        let(:user) { create(:user) }

        it 'returns a failure' do
          # given
          password = 'invalid_password'

          # when
          result = described_class.call(email: user.email, password:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # given
          password = 'invalid_password'

          # when
          result = described_class.call(email: user.email, password:)

          # then
          expect(result[:errors]).to include(
            password: ['is invalid']
          )
        end
      end
    end

    describe 'success' do
      it 'returns a success' do
        # given
        password = 'password'
        user = create(:user, password_digest: BCrypt::Password.create(password))

        # when
        result = described_class.call(email: user.email, password:)

        # then
        expect(result).to be_a_success
      end

      it 'exposes a token' do
        # given
        password = 'password'
        user = create(:user, password_digest: BCrypt::Password.create(password))

        # when
        result = described_class.call(email: user.email, password:)

        # then
        expect(result[:token]).to be_a(String)
        expect(result[:token].start_with?('ey')).to be(true)
      end

      it 'sets the correct payload' do
        # given
        password = 'password'
        user = create(:user, password_digest: BCrypt::Password.create(password))

        # when
        result = described_class.call(email: user.email, password:)

        decoded_token = JWT.decode(
          result[:token],
          Rails.application.credentials.secret_key,
          true,
          { algorithm: 'HS256' }
        )

        # then
        expect(decoded_token.first).to include(
          'email' => user.email,
          'exp' => (Date.today + 1.month).to_time.to_i,
          'id' => user.id
        )
      end
    end
  end
end

