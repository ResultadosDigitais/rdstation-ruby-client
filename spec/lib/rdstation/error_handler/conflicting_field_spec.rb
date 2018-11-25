require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::ConflictingField do
  describe '#raise_error' do
    subject(:conflicting_field_errors) { described_class.new(errors) }

    context 'when none of the errors are conflicting field errors' do
      let(:errors) do
        [
          {
            'error_type' => 'RANDOM_ERROR_TYPE',
            'error_message' => 'Random error message'
          }
        ]
      end

      it 'does not raise the error' do
        result = conflicting_field_errors.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there is a conflict field errors' do
      let(:errors) do
        [
          {
            'error_type' => 'CONFLICTING_FIELD',
            'error_message' => 'The payload contains an attribute that was used to identify the lead'
          }
        ]
      end

      it 'raises the error' do
        expect do
          conflicting_field_errors.raise_error
        end.to raise_error(RDStation::Error::ConflictingField)
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise the error' do
        result = conflicting_field_errors.raise_error
        expect(result).to be_nil
      end
    end
  end
end
