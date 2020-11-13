require 'spec_helper'

RSpec.describe RDStation::Authentication do
  let(:token_endpoint) { 'https://api.rd.services/auth/token' }
  let(:request_headers) { { 'Content-Type' => 'application/json' } }

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

  let(:token_request_with_valid_refresh_token) do
    {
      client_id: 'client_id',
      client_secret: 'client_secret',
      refresh_token: 'valid_refresh_token'
    }
  end

  let(:token_request_with_invalid_refresh_token) do
    {
      client_id: 'client_id',
      client_secret: 'client_secret',
      refresh_token: 'invalid_refresh_token'
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
        errors: {
          error_type: 'ACCESS_DENIED',
          error_message: 'Wrong credentials provided.'
        }
      }.to_json
    }
  end

  let(:expired_code_response) do
    {
      status: 401,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        errors: {
          error_type: 'EXPIRED_CODE_GRANT',
          error_message: 'The authorization code grant has expired.'
        }
      }.to_json
    }
  end

  let(:authentication) { described_class.new('client_id', 'client_secret') }

  describe '#auth_url' do
    let(:configuration_client_id) { 'configuration_client_id' }
    let(:configuration_client_secret) { 'configuration_client_secret' }
    let(:redirect_uri) { 'redirect_uri' }
    before do
      RDStation.configure do |config|
        config.client_id = configuration_client_id
        config.client_secret = configuration_client_secret
      end
    end

    context 'when client_id and client_secret are specified in initialization' do
      it 'uses those specified in initialization' do
        auth = described_class.new('initialization_client_id', 'initialization_client_secret')
        expected = "https://api.rd.services/auth/dialog?client_id=initialization_client_id&redirect_uri=#{redirect_uri}"
        expect(auth.auth_url(redirect_uri)).to eq expected
      end
    end

    context 'when client_id and client_secret are specified only in configuration' do
      it 'uses those specified in configuration' do
        auth = described_class.new
        expected = "https://api.rd.services/auth/dialog?client_id=#{configuration_client_id}&redirect_uri=#{redirect_uri}"
        expect(auth.auth_url(redirect_uri)).to eq expected
      end
    end
  end

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

    context 'when client_id and client_secret are specified only in configuration' do
      let(:authentication) { described_class.new }
      let(:configuration_client_id) { 'configuration_client_id' }
      let(:configuration_client_secret) { 'configuration_client_secret' }
      let(:token_request_with_valid_code_secrets_from_config) do
        {
          client_id: configuration_client_id,
          client_secret: configuration_client_secret,
          code: 'valid_code'
        }
      end
      before do
        RDStation.configure do |config|
          config.client_id = configuration_client_id
          config.client_secret = configuration_client_secret
        end

        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_valid_code_secrets_from_config.to_json
          )
          .to_return(credentials_response)
      end

      it 'returns the credentials' do
        credentials_request = authentication.authenticate('valid_code')
        expect(credentials_request).to eq(credentials)
      end
    end
  end

  describe '#update_access_token' do
    context 'when the refresh token is valid' do
      before do
        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_valid_refresh_token.to_json
          )
          .to_return(credentials_response)
      end

      it 'returns the credentials' do
        credentials_request = authentication.update_access_token('valid_refresh_token')
        expect(credentials_request).to eq(credentials)
      end
    end

    context 'when the refresh token is invalid' do
      let(:invalid_refresh_token_response) do
        {
          status: 401,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            errors: {
              error_type: 'INVALID_REFRESH_TOKEN',
              error_message: 'The provided refresh token is invalid or was revoked.'
            }
          }.to_json
        }
      end

      before do
        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_invalid_refresh_token.to_json
          )
          .to_return(invalid_refresh_token_response)
      end

      it 'returns an auth error' do
        expect do
          authentication.update_access_token('invalid_refresh_token')
        end.to raise_error(RDStation::Error::InvalidRefreshToken)
      end
    end

    context 'when client_id and client_secret are specified only in configuration' do
      let(:authentication) { described_class.new }
      let(:configuration_client_id) { 'configuration_client_id' }
      let(:configuration_client_secret) { 'configuration_client_secret' }
      let(:token_request_with_valid_refresh_code_secrets_from_config) do
        {
          client_id: configuration_client_id,
          client_secret: configuration_client_secret,
          refresh_token: 'valid_refresh_token'
        }
      end
      before do
        RDStation.configure do |config|
          config.client_id = configuration_client_id
          config.client_secret = configuration_client_secret
        end

        stub_request(:post, token_endpoint)
          .with(
            headers: request_headers,
            body: token_request_with_valid_refresh_code_secrets_from_config.to_json
          )
          .to_return(credentials_response)
      end

      it 'returns the credentials' do
        credentials_request = authentication.update_access_token('valid_refresh_token')
        expect(credentials_request).to eq(credentials)
      end
    end
  end

  describe ".revoke" do
    let(:revoke_endpoint) { 'https://api.rd.services/auth/revoke' }
    let(:request_headers) do
      {
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
    end

    context "valid access_token" do
      let(:access_token) { "valid_access_token" }

      let(:ok_response) do
        {
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: {}.to_json
        }
      end

      before do
        stub_request(:post, revoke_endpoint)
          .with(
            headers: request_headers,
            body: URI.encode_www_form({
              token: access_token,
              token_type_hint: 'access_token'
            })
          )
          .to_return(ok_response)
      end

      it "returns 200 code with an empty hash in the body" do
        request_response = RDStation::Authentication.revoke(access_token: access_token)
        expect(request_response).to eq({})
      end
    end

    context "invalid access token" do
      let(:access_token) { "invalid_access_token" }

      let(:unauthorized_response) do
        {
          status: 401,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            errors: {
              error_type: 'UNAUTHORIZED',
              error_message: 'Invalid token.'
            }
          }.to_json
        }
      end

      before do
        stub_request(:post, revoke_endpoint)
          .with(
            headers: request_headers,
            body: URI.encode_www_form({
              token: access_token,
              token_type_hint: 'access_token'
            })
          )
          .to_return(unauthorized_response)
      end

      it "raises unauthorized" do
        expect do
          RDStation::Authentication.revoke(access_token: access_token)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end
  end
end
