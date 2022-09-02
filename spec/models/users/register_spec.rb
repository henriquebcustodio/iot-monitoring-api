require 'rails_helper'

RSpec.describe Users::Register do
  describe '.call' do
    describe 'failures' do
      context 'with a blank passwords' do
        # given
        let(:email) { 'henrique@husky.io' }

        it 'returns a failure' do
          # when
          password =  ['', nil, ' '].sample
          password_confirmation = ['', nil, ' '].sample

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # when
          password = ['', nil, ' '].sample
          password_confirmation = ['', nil, ' '].sample

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            password_confirmation: ["can't be blank"],
            password: ["can't be blank"]
          )
        end
      end

      context "when password confirmation doesn't match password" do
        # given
        let(:email) { 'henrique@husky.io' }

        it 'returns a failure' do
          # when
          password = 'sample'
          password_confirmation = 'invalid'

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # when
          password = 'sample'
          password_confirmation = 'invalid'

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            password_confirmation: ["doesn't match password"]
          )
        end
      end

      context 'with a blank email' do
        # given
        let(:password) { 'sample' }
        let(:password_confirmation) { 'sample' }

        it 'returns a failure' do
          # when
          email = ['', ' ', nil].sample

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # when
          email = ['', ' ', nil].sample

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            email: ["can't be blank"]
          )
        end
      end

      context 'with an invalid email' do
        # given
        let(:password) { 'sample' }
        let(:password_confirmation) { 'sample' }

        it 'returns a failure' do
          # when
          email = [[], {}, 'henrique@', 'email'].sample

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result).to be_a_failure
        end

        it 'exposes the errors' do
          # when
          email = [[], {}, 'henrique@', 'email'].sample

          result = described_class.call(email:, password:, password_confirmation:)

          # then
          expect(result[:errors]).to include(
            email: ['is invalid']
          )
        end
      end
    end

    describe 'success' do
      # given
      let(:email) { 'henrique@husky.io' }
      let(:password) { 'password' }
      let(:password_confirmation) { password }

      it 'creates the user' do
        # when
        result = described_class.call(email:, password:, password_confirmation:)

        # then
        expect(result).to be_a_success
      end

      it 'exposes the user' do
        # when
        result = described_class.call(email:, password:, password_confirmation:)

        # then
        expect(result[:user]).to include(
          'email' => email,
          'id' => 1
        )
      end
    end
  end
end
