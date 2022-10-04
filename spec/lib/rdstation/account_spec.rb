require 'spec_helper'

RSpec.describe RDStation::Account do
  let(:endpoint_valid) { "https://api.rd.services/marketing/account_info" }

  let(:valid_access_token) { 'valid_access_token' }
  let(:invalid_access_token) { 'invalid_access_token' }
  let(:expired_access_token) { 'expired_access_token' }

  let(:account_with_valid_token) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: valid_access_token))
  end
  let(:account_with_expired_token) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: expired_access_token))
  end
  let(:account_with_invalid_token) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: invalid_access_token))
  end


  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{valid_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_token_headers) do
    {
      'Authorization' => "Bearer #{invalid_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:expired_token_headers) do
    {
      'Authorization' => "Bearer #{expired_access_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:not_found_response) do
    {
      status: 404,
      body: {
        errors: {
          error_type: 'RESOURCE_NOT_FOUND',
          error_message: 'Lead not found.'
        }
      }.to_json
    }
  end

  let(:invalid_token_response) do
    {
      status: 401,
      body: {
        errors: {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      }.to_json
    }
  end

  let(:conflicting_field_response) do
    {
      status: 400,
      body: {
        errors: {
          error_type: 'CONFLICTING_FIELD',
          error_message: 'The payload contains an attribute that was used to identify the resource.'
        }
      }.to_json
    }
  end

  let(:unrecognized_error) do
    {
      status: 400,
      body: {
        errors: {
          error_type: 'unrecognized error',
          error_message: 'Unexpected error.'
        }
      }.to_json
    }
  end

  let(:expired_token_response) do
    {
      status: 401,
      headers: { 'WWW-Authenticate' => 'Bearer realm="https://api.rd.services/", error="expired_token", error_description="The access token expired"' },
      body: {
        errors: {
          error_type: 'UNAUTHORIZED',
          error_message: 'Invalid token.'
        }
      }.to_json
    }
  end

  describe '#info' do
    it 'calls retryable_request' do
      expect(account_with_valid_token).to receive(:retryable_request)
      account_with_valid_token.info
    end

    context 'with a valid auth token' do
      context 'when the account exists' do
        let(:account) do
          { 'name' => 'Valid account' }
        end

        before do
          stub_request(:get, endpoint_valid)
            .with(headers: valid_headers)
            .to_return(status: 200, body: account.to_json)
        end

        it 'returns the account' do
          response = account_with_valid_token.info
          expect(response).to eq(account)
        end
      end
    end

    context 'with an invalid auth token' do
      before do
        stub_request(:get, endpoint_valid)
          .with(headers: invalid_token_headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          account_with_invalid_token.info
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      before do
        stub_request(:get, endpoint_valid)
          .with(headers: expired_token_headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          account_with_expired_token.info
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end
end
