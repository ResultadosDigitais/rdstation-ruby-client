require 'spec_helper'

RSpec.describe RDStation::ErrorHandler do
  describe '#raise_errors' do
    subject(:error_handler) { described_class.new(error_response) }

    context 'when the error type is recognized' do
      let(:error_response) do
        OpenStruct.new(
          code: 400,
          body: {
            'errors' => {
              'error_type' => 'CONFLICTING_FIELD',
              'error_message' => 'Error Message'
            }
          }.to_json
        )
      end

      it 'raises the corresponding error class' do
        expect { error_handler.raise_error }.to raise_error(RDStation::Error::ConflictingField, 'Error Message')
      end
    end
  end
end
