require 'spec_helper'

RSpec.describe RDStation::ErrorHandler::ExpiredAccessToken do
  describe '#raise_error' do

    subject(:expired_access_token_error) { described_class.new(errors) }

    context 'when there is an expired token error' do
      let(:errors) do
        [
          {
            'headers' => {
              'www-authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"'
            },
            'error_message' => 'Error Message',
            'error_type' => 'EXPIRED_TOKEN_ERROR'
          }
        ]
      end

      it 'raises an ExpiredAccessToken error' do
        expect do
          expired_access_token_error.raise_error
        end.to raise_error(RDStation::Error::ExpiredAccessToken, 'Error Message')
      end
    end

    context 'when the errors does not contain a header' do
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

      it 'does not raise an ExpiredAccessToken error' do
        result = expired_access_token_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when none of the errors are expired token errors' do
      let(:errors) do
        [
          {
            'headers' => {
              'Content-Type' => 'application/json'
            },
            'error_message' => 'Error Message',
            'error_type' => 'RANDOM_ERROR_TYPE'
          },
          {
            'headers' => {
              'Content-Type' => 'application/json'
            },
            'error_message' => 'Another Error Message',
            'error_type' => 'ANOTHER_RANDOM_ERROR_TYPE'
          }
        ]
      end

      it 'does not raise an ExpiredAccessToken error' do
        result = expired_access_token_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when there are no errors' do
      let(:errors) { [] }

      it 'does not raise an ExpiredAccessToken error' do
        result = expired_access_token_error.raise_error
        expect(result).to be_nil
      end
    end

    context 'when the expired token header is x-amzn-remapped-www-authenticate' do
      let(:errors) do
        [
          {
            'headers' => {
              'x-amzn-remapped-www-authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"'
            },
            'error_message' => 'Error Message',
            'error_type' => 'EXPIRED_TOKEN_ERROR'
          }
        ]
      end

      it 'raises an ExpiredAccessToken error' do
        expect do
          expired_access_token_error.raise_error
        end.to raise_error(RDStation::Error::ExpiredAccessToken, 'Error Message')
      end
    end
  end
end
