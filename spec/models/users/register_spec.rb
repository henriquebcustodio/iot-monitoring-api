require 'rails_helper'

RSpec.describe Users::Register do
  describe '.call' do
    describe 'failures' do
      context 'with a blank passwords' do
        let(:email) { 'henrique@husky.io' }

        it 'returns a failure' do
          # given
          password = ['', nil, ' '].sample
          password_confirmation = ['', nil, ' '].sample

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          password = ['', nil, ' '].sample
          password_confirmation = ['', nil, ' '].sample

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            password_confirmation: ["can't be blank"],
            password: ["can't be blank"]
          )
        end
      end

      context "when password confirmation doesn't match password" do
        let(:email) { 'henrique@husky.io' }

        it 'returns a failure' do
          # given
          password = 'sample'
          password_confirmation = 'invalid'

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          password = 'sample'
          password_confirmation = 'invalid'

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            password_confirmation: ["doesn't match password"]
          )
        end
      end

      context 'with a blank email' do
        let(:password) { 'sample' }
        let(:password_confirmation) { 'sample' }

        it 'returns a failure' do
          # given
          email = ['', ' ', nil].sample

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          email = ['', ' ', nil].sample

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            email: ["can't be blank"]
          )
        end
      end

      context 'with an invalid email' do
        let(:password) { 'sample' }
        let(:password_confirmation) { 'sample' }

        it 'returns a failure' do
          # given
          email = [[], {}, 'henrique@', 'email'].sample

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # given
          email = [[], {}, 'henrique@', 'email'].sample

          # when
          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            email: ['is invalid']
          )
        end
      end
    end

    describe 'success' do
      it 'creates the user' do
        # given
        email = 'henrique@husky.io'
        password = 'password'
        password_confirmation = password

        # when
        result = described_class.call(email:, password:, password_confirmation:)

        # then
        expect(result).to be_a_success
      end

      it 'exposes the user' do
        # given
        email = 'henrique@husky.io'
        password = 'password'
        password_confirmation = password

        # when
        result = described_class.call(email:, password:, password_confirmation:)

        # then
        expect(result[:user]).to include(
          'email' => email
        )
      end
    end
  end
end
