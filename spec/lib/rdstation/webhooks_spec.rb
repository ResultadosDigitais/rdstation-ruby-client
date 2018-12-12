require 'spec_helper'

RSpec.describe RDStation::Webhooks do
  let(:valid_auth_token) { 'valid_auth_token' }
  let(:invalid_auth_token) { 'invalid_auth_token' }
  let(:expired_auth_token) { 'expired_auth_token' }

  let(:webhook_with_valid_token) { described_class.new(valid_auth_token) }
  let(:webhook_with_expired_token) { described_class.new(expired_auth_token) }
  let(:webhook_with_invalid_token) { described_class.new(invalid_auth_token) }

  let(:webhooks_endpoint) { 'https://api.rd.services/integrations/webhooks/' }

  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{valid_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_token_headers) do
    {
      'Authorization' => "Bearer #{invalid_auth_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:expired_token_headers) do
    {
      'Authorization' => "Bearer #{expired_auth_token}",
      'Content-Type' => 'application/json'
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

  describe '#all' do
    context 'with a valid auth token' do
      let(:webhooks) do
        {
          'webhooks' => [
            {
              'uuid' => '5408c5a3-4711-4f2e-8d0b-13407a3e30f3',
              'event_type' => 'WEBHOOK.CONVERTED',
              'entity_type' => 'CONTACT',
              'url' => 'http =>//my-url.com',
              'http_method' => 'POST',
              'include_relations' => []
            },
            {
              'uuid' => '642d985c-487c-4c53-b9de-2c1223841cae',
              'event_type' => 'WEBHOOK.MARKED_OPPORTUNITY',
              'entity_type' => 'CONTACT',
              'url' => 'http://my-url.com',
              'http_method' => 'POST',
              'include_relations' => %w[COMPANY CONTACT_FUNNEL]
            }
          ]
        }
      end

      before do
        stub_request(:get, webhooks_endpoint)
          .with(headers: valid_headers)
          .to_return(status: 200, body: webhooks.to_json)
      end

      it 'returns all webhooks' do
        response = webhook_with_valid_token.all
        expect(response).to eq(webhooks)
      end
    end

    context 'with an invalid auth token' do
      before do
        stub_request(:get, webhooks_endpoint)
          .with(headers: invalid_token_headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          webhook_with_invalid_token.all
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      before do
        stub_request(:get, webhooks_endpoint)
          .with(headers: expired_token_headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          webhook_with_expired_token.all
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end

  describe '#by_uuid' do
    let(:uuid) { '5408c5a3-4711-4f2e-8d0b-13407a3e30f3' }
    let(:webhooks_endpoint_by_uuid) { webhooks_endpoint + uuid }

    context 'with a valid auth token' do
      let(:webhook) do
        {
          'uuid' => uuid,
          'event_type' => 'WEBHOOK.CONVERTED',
          'entity_type' => 'CONTACT',
          'url' => 'http =>//my-url.com',
          'http_method' => 'POST',
          'include_relations' => []
        }
      end

      before do
        stub_request(:get, webhooks_endpoint_by_uuid)
          .with(headers: valid_headers)
          .to_return(status: 200, body: webhook.to_json)
      end

      it 'returns the webhook' do
        response = webhook_with_valid_token.by_uuid(uuid)
        expect(response).to eq(webhook)
      end
    end

    context 'with an invalid auth token' do
      before do
        stub_request(:get, webhooks_endpoint_by_uuid)
          .with(headers: invalid_token_headers)
          .to_return(invalid_token_response)
      end

      it 'raises an invalid token error' do
        expect do
          webhook_with_invalid_token.by_uuid(uuid)
        end.to raise_error(RDStation::Error::Unauthorized)
      end
    end

    context 'with an expired auth token' do
      before do
        stub_request(:get, webhooks_endpoint_by_uuid)
          .with(headers: expired_token_headers)
          .to_return(expired_token_response)
      end

      it 'raises a expired token error' do
        expect do
          webhook_with_expired_token.by_uuid(uuid)
        end.to raise_error(RDStation::Error::ExpiredAccessToken)
      end
    end
  end
end
