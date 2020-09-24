require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::InvalidRefreshToken do
  describe '#raise_error' do
    subject(:invalid_refresh_token) { described_class.new(errors) }

    context 'when the refresh token is invalid or was revoked' do
      let(:errors) do
        [
          {
            'error_type' => 'INVALID_REFRESH_TOKEN',
            'error_message' => 'Error Message',
          }
        ]
      end

      it 'raises an InvalidRefreshToken error' do
        expect do
          invalid_refresh_token.raise_error
        end.to raise_error(RDStation::Error::InvalidRefreshToken, 'Error Message')
      end
    end

    context 'when none of the errors are invalid refresh token errors' do
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

      it 'does not raise an InvalidRefreshToken error' do
        result = invalid_refresh_token.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an InvalidRefreshToken error' do
        result = invalid_refresh_token.raise_error
        expect(result).to be_nil
      end
    end
  end
end
