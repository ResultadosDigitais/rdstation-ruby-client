require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::InvalidCredentials do
  describe '#raise_error' do

    subject(:invalid_credentials_error) { described_class.new(errors) }

    context 'when there are invalid credentials errors' do
      let(:errors) do
        [
          {
            'error_message' => 'Error Message',
            'error_type' => 'ACCESS_DENIED'
          }
        ]
      end

      it 'raises an InvalidCredentials error' do
        expect do
          invalid_credentials_error.raise_error
        end.to raise_error(RDStation::Error::InvalidCredentials, 'Error Message')
      end
    end

    context 'when none of the errors are invalid credentials errors' do
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

      it 'does not raise an InvalidCredentials error' do
        result = invalid_credentials_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an InvalidCredentials error' do
        result = invalid_credentials_error.raise_error
        expect(result).to be_nil
      end
    end
  end
end
