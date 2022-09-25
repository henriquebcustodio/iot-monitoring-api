require 'rails_helper'

RSpec.describe Broker::Authenticate do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid token' do
        it 'returns a failure' do
          # given
          token = '1234567890'

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_failure
        end
      end
    end

    describe 'success' do
      context 'with a valid token' do
        it 'returns a success' do
          # given
          token = ENV['BROKER_TOKEN']

          # when
          result = described_class.call(token:)

          # then
          expect(result).to be_a_success
        end
      end
    end
  end
end
