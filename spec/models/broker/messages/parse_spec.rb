require 'rails_helper'

RSpec.describe Broker::Messages::Parse do
  describe '.call' do
    describe 'failures' do
      context 'with an invalid input type' do
        it 'returns a failure' do
          # given
          message = [nil, [], Object.new].sample

          # when
          result = described_class.call(message:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:invalid_attributes)
          expect(result[:errors]).to include(:message)
        end
      end

      context "when the message isn't a valid JSON" do
        it 'returns a failure' do
          # given
          message = ['', 'invalid', '{key: value}'].sample

          # when
          result = described_class.call(message:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:parsing_failed)
          expect(result.data).to eq(parsing_failed: true)
        end
      end
    end

    describe 'success' do
      context 'with a valid JSON' do
        it 'returns a success' do
          # given
          message_hash = { 'temperature' => 15, 'pressure' => 10 }

          # when
          result = described_class.call(message: message_hash.to_json)

          # then
          expect(result).to be_a_success
          expect(result.type).to be(:message_parsed)
        end

        it 'exposes the parsed message' do
          # given
          message_hash = { 'temperature' => 15, 'pressure' => 10 }

          # when
          result = described_class.call(message: message_hash.to_json)

          # then
          expect(result.data.keys).to contain_exactly(:message)
          expect(result[:message]).to eq(message_hash)
        end
      end
    end
  end
end
