require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::Unauthorized do
  describe '#raise_error' do

    subject(:unauthorized_error) { described_class.new(errors) }

    context 'when there is an unauthorized error' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'UNAUTHORIZED'
          }
        ]
      end

      it 'raises an Unauthorized error' do
        expect do
          unauthorized_error.raise_error
        end.to raise_error(RDStation::Error::Unauthorized, 'Error Message')
      end
    end

    context 'when none of the errors are unauthorized errors' do
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

      it 'does not raise an Unauthorized error' do
        result = unauthorized_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an Unauthorized error' do
        result = unauthorized_error.raise_error
        expect(result).to be_nil
      end
    end
  end
end
