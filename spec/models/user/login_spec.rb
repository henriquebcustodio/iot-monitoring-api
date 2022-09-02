require 'rails_helper'

RSpec.describe Users::Login do
  describe '.call' do
    describe 'failures' do
      context "when user doesn't exist" do
        # given
        let(:password) { 'sample' }

        it 'returns a failure' do
          # when
          email = 'henrique@gmail.com'

          result = described_class.call(email:, password:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # when
          email = 'henrique@gmail.com'

          result = described_class.call(email:, password:)

          # then
          expect(result[:errors]).to include(
            id: ['not found']
          )
        end
      end

      context 'with an invalid password' do
        # given
        let(:user) { User.create(email: 'henrique@gmail.com', password: 'password') }

        it 'returns a failure' do
          # when
          password = 'invalid_password'

          result = described_class.call(email: user.email, password:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the error' do
          # when
          password = 'invalid_password'

          result = described_class.call(email: user.email, password:)

          # then
          expect(result[:errors]).to include(
            password: ['is invalid']
          )
        end
      end
    end

    describe 'success' do
      # given
      let(:user) { User.create(email: 'henrique@gmail.com', password: 'password') }

      it 'returns a success' do
        # when
        result = described_class.call(email: user.email, password: user.password)

        # then
        expect(result).to be_a_success
      end

      it 'exposes a token' do
        # when
        result = described_class.call(email: user.email, password: user.password)

        # then
        expect(result[:token]).to be_a(String)
        expect(result[:token].start_with?('ey')).to be(true)
      end

      it 'sets the correct payload' do
        # when
        result = described_class.call(email: user.email, password: user.password)

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

