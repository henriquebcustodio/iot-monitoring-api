require 'rails_helper'

RSpec.describe DataPoint do
  describe '#as_json' do
    it 'hides the unwanted values' do
      # given
      data_point = create(:data_point)

      # when
      result = data_point.as_json

      # then
      expect(result).not_to include(
        'bool_value',
        'numeric_value',
        'text_value'
      )
    end

    context 'with a numeric variable' do
      it 'exposes the computed value' do
        # given
        data_point = create(:data_point)

        # when
        result = data_point.as_json

        # then
        expect(result).to include('value')
        expect(result['value']).to eq(data_point.numeric_value)
      end
    end

    context 'with a boolean variable' do
      it 'exposes the computed value' do
        # given
        data_point = create(:data_point, :boolean)

        # when
        result = data_point.as_json

        # then
        expect(result).to include('value')
        expect(result['value']).to eq(data_point.bool_value)
      end
    end

    context 'with a text variable' do
      it 'exposes the computed value' do
        # given
        data_point = create(:data_point, :text)

        # when
        result = data_point.as_json

        # then
        expect(result).to include('value')
        expect(result['value']).to eq(data_point.text_value)
      end
    end
  end
end
