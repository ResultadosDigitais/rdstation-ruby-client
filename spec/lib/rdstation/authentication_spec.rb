require 'spec_helper'

RSpec.describe RDStation::Authentication do
  let(:token_endpoint) { 'https://api.rd.services/auth/token' }
  let(:request_headers) { { 'Accept-Encoding' => 'identity' } }

  let(:token_request_with_valid_code) do
    {
      client_id: 'client_id',
      client_secret: 'client_secret',
      code: 'valid_code'
    }
  end

  let(:token_request_with_invalid_code) do
    {
      client_id: 'client_id',
      client_secret: 'client_secret',
      code: 'invalid_code'
    }
  end

  let(:token_request_with_expired_code) do
    {
      client_id: 'client_id',
      client_secret: 'client_secret',
      code: 'expired_code'
    }
  end

  let(:credentials) do
    {
      'access_token' => '123456',
      'expires_in' => 86_400,
      'refresh_token' => 'refreshtoken'
    }
  end

  let(:credentials_response) do
    {
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: credentials.to_json
    }
  end

  let(:invalid_code_response) do
    {
      status: 401,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        error_type: 'ACCESS_DENIED',
        error_message: 'Wrong credentials provided.'
      }.to_json
    }
  end

  let(:expired_code_response) do
    {
      status: 401,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        error_type: 'EXPIRED_CODE_GRANT',
        error_message: 'The authorization code grant has expired.'
      }.to_json
    }
  end

  let(:authentication) { described_class.new('client_id', 'client_secret') }

  describe '#authenticate' do
    context 'when the code is valid' do
      before do
        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_valid_code.to_json
          )
          .to_return(credentials_response)
      end

      it 'returns the credentials' do
        credentials_request = authentication.authenticate('valid_code')
        expect(credentials_request).to eq(credentials)
      end
    end

    context 'when the code is invalid' do
      before do
        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_invalid_code.to_json
          )
          .to_return(invalid_code_response)
      end

      it 'returns an auth error' do
        expect do
          authentication.authenticate('invalid_code')
        end.to raise_error(RDStation::Error::InvalidCredentials)
      end
    end

    context 'when the code has expired' do
      before do
        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_expired_code.to_json
          )
          .to_return(expired_code_response)
      end

      it 'returns an expired code error' do
        expect do
          authentication.authenticate('expired_code')
        end.to raise_error(RDStation::Error::ExpiredCodeGrant)
      end
    end
  end
end
