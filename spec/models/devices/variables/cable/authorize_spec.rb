require 'rails_helper'

RSpec.describe Devices::Variables::Cable::Authorize do
  describe '.call' do
    describe 'failures' do
      context "when the variable doesn't exist" do
        it 'returns a failure' do
          # given
          user = create(:user)
          variable_id = 1

          # when
          result = described_class.call(user_id: user.id, variable_id:)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:variable_not_found)
          expect(result.data).to eq(variable_not_found: true)
        end
      end

      context 'when the variable belongs to another user' do
        it 'returns a failure' do
          # given
          variable = create(:variable)
          other_user = create(:user)

          # when
          result = described_class.call(user_id: other_user.id, variable_id: variable.id)

          # then
          expect(result).to be_a_failure
          expect(result.type).to be(:unauthorized)
          expect(result.data).to eq(unauthorized: true)
        end
      end
    end

    describe 'success' do
      it 'returns a success' do
        # given
        variable = create(:variable)

        # when
        result = described_class.call(user_id: variable.user.id, variable_id: variable.id)

        # then
        expect(result).to be_a_success
        expect(result.type).to be(:authorized)
      end

      it 'exposes the variable' do
        # given
        variable = create(:variable)

        # when
        result = described_class.call(user_id: variable.user.id, variable_id: variable.id)

        # then
        expect(result.data).to eq(variable:)
      end
    end
  end
end
