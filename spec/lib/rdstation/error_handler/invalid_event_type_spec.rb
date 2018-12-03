require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::InvalidEventType do
  describe '#raise_error' do
    subject(:invalid_event_type_error) { described_class.new(errors) }

    context 'when there is a invalid event type error' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'INVALID_OPTION',
            'path' => '$.event_type'
          }
        ]
      end

      it 'raises an InvalidEventType error' do
        expect do
          invalid_event_type_error.raise_error
        end.to raise_error(RDStation::Error::InvalidEventType, 'Error Message')
      end
    end

    context 'when none of the errors are invalid event type errors' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'RANDOM_ERROR_TYPE'
          },
          {
            'error_message' => 'Another Error Message',
            'error_type' => 'ANOTHER_RANDOM_ERROR_TYPE'
          }
        ]
      end

      it 'does not raise an InvalidEventType error' do
        result = invalid_event_type_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an InvalidEventType error' do
        result = invalid_event_type_error.raise_error
        expect(result).to be_nil
      end
    end
  end
end
