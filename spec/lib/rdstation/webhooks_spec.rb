require 'spec_helper'

RSpec.describe RDStation::Webhooks do
  let(:webhooks_client) { described_class.new(access_token: 'access_token') }
  let(:webhooks_endpoint) { 'https://api.rd.services/integrations/webhooks/' }

  let(:headers) do
    {
      'Authorization' => 'Bearer access_token',
      'Content-Type' => 'application/json'
    }
  end

  let(:error_handler) do
    instance_double(RDStation::ErrorHandler, raise_errors: 'mock raised errors')
  end

  before do
    allow(RDStation::ErrorHandler).to receive(:new).and_return(error_handler)
  end

  describe '#all' do
    context 'when the request is successful' do
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
          .with(headers: headers)
          .to_return(status: 200, body: webhooks.to_json)
      end

      it 'returns all webhooks' do
        response = webhooks_client.all
        expect(response).to eq(webhooks)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, webhooks_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_errors on error handler' do
        webhooks_client.all
        expect(error_handler).to have_received(:raise_errors)
      end
    end
  end

  describe '#by_uuid' do
    let(:uuid) { '5408c5a3-4711-4f2e-8d0b-13407a3e30f3' }
    let(:webhooks_endpoint_by_uuid) { webhooks_endpoint + uuid }

    context 'when the request is successful' do
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
          .with(headers: headers)
          .to_return(status: 200, body: webhook.to_json)
      end

      it 'returns the webhook' do
        response = webhooks_client.by_uuid(uuid)
        expect(response).to eq(webhook)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, webhooks_endpoint_by_uuid)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_errors on error handler' do
        webhooks_client.by_uuid(uuid)
        expect(error_handler).to have_received(:raise_errors)
      end
    end
  end

  describe '#create' do
    let(:payload) do
      {
        'entity_type' =>  'CONTACT',
        'event_type' =>  'WEBHOOK.CONVERTED',
        'url' =>  'http://my-url.com',
        'http_method' => 'POST',
        'include_relations' => %w[COMPANY CONTACT_FUNNEL]
      }
    end

    context 'when the request is successful' do
      let(:webhook) do
        {
          'uuid' => '5408c5a3-4711-4f2e-8d0b-13407a3e30f3',
          'event_type' => 'WEBHOOK.CONVERTED',
          'entity_type' => 'CONTACT',
          'url' => 'http =>//my-url.com',
          'http_method' => 'POST',
          'include_relations' => %w[COMPANY CONTACT_FUNNEL]
        }
      end

      before do
        stub_request(:post, webhooks_endpoint)
          .with(headers: headers, body: payload.to_json)
          .to_return(status: 200, body: webhook.to_json)
      end

      it 'returns the webhook' do
        response = webhooks_client.create(payload)
        expect(response).to eq(webhook)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:post, webhooks_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_errors on error handler' do
        webhooks_client.create(payload)
        expect(error_handler).to have_received(:raise_errors)
      end
    end
  end

  describe '#update' do
    let(:uuid) { '5408c5a3-4711-4f2e-8d0b-13407a3e30f3' }
    let(:webhooks_endpoint_by_uuid) { webhooks_endpoint + uuid }
    let(:new_payload) do
      {
        'entity_type' =>  'CONTACT',
        'event_type' =>  'WEBHOOK.MARKED_OPPORTUNITY',
        'url' =>  'http://my-new-url.com',
        'http_method' => 'POST',
        'include_relations' => %w[CONTACT_FUNNEL]
      }
    end

    context 'when the request is successful' do
      let(:updated_webhook) do
        {
          'uuid' => uuid,
          'event_type' => 'WEBHOOK.MARKED_OPPORTUNITY',
          'entity_type' => 'CONTACT',
          'url' => 'http://my-new-url.com',
          'http_method' => 'POST',
          'include_relations' => %w[CONTACT_FUNNEL]
        }
      end

      before do
        stub_request(:put, webhooks_endpoint_by_uuid)
          .with(headers: headers, body: new_payload.to_json)
          .to_return(status: 200, body: updated_webhook.to_json)
      end

      it 'returns the webhook' do
        response = webhooks_client.update(uuid, new_payload)
        expect(response).to eq(updated_webhook)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:put, webhooks_endpoint_by_uuid)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_errors on error handler' do
        webhooks_client.update(uuid, new_payload)
        expect(error_handler).to have_received(:raise_errors)
      end
    end
  end

  describe '#delete' do
    let(:uuid) { '5408c5a3-4711-4f2e-8d0b-13407a3e30f3' }
    let(:webhooks_endpoint_by_uuid) { webhooks_endpoint + uuid }

    context 'when the request is successful' do
      before do
        stub_request(:delete, webhooks_endpoint_by_uuid).with(headers: headers).to_return(status: 204)
      end

      it 'returns the webhook' do
        response = webhooks_client.delete(uuid)
        expect(response).to eq(message: 'Webhook deleted successfuly!')
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:delete, webhooks_endpoint_by_uuid)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_errors on error handler' do
        webhooks_client.delete(uuid)
        expect(error_handler).to have_received(:raise_errors)
      end
    end
  end
end
