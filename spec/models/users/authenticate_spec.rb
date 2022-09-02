require 'rails_helper'

RSpec.describe Users::Authenticate do
  def generate_token(payload)
    secret_key = Rails.application.credentials.secret_key

    JWT.encode payload, secret_key, 'HS256'
  end

  describe '.call' do
    describe 'failures' do
      context 'with invalid token' do
        it 'returns a failure' do
          # given
          token = ['', {}, [], 'asd'].sample

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:invalid_token)
        end

        it 'exposes the error' do
          # given
          token = ['', {}, [], 'asd'].sample

          # when
          result = described_class.call(token:)

          # then
          expect(result[:errors]).to include(
            token: 'is invalid'
          )
        end
      end

      context 'with expired token' do
        it 'returns a failure' do
          # given
          token = generate_token({ exp: Date.yesterday.to_time.to_i, id: 1, email: 'henrique@gmail.com' })

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:expired_token)
        end

        it 'exposes the error' do
          # given
          token = generate_token({ exp: Date.yesterday.to_time.to_i, id: 1, email: 'henrique@gmail.com' })

          # when
          result = described_class.call(token:)

          # then
          expect(result[:errors]).to include(
            token: 'is expired'
          )
        end
      end
    end

    describe 'success' do
      context 'with a valid token' do
        it 'returns a success' do
          # given
          token = generate_token({ exp: Date.tomorrow.to_time.to_i, id: 1, email: 'henrique@gmail.com' })

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_success
        end

        it 'exposes the payload' do
          # given
          token = generate_token({ exp: Date.tomorrow.to_time.to_i, id: 1, email: 'henrique@gmail.com' })

          # when
          result = described_class.call(token:)

          # then
          expect(result[:token_payload]).to include(
            'id' => 1,
            'email' => 'henrique@gmail.com'
          )
        end
      end
    end
  end
end
