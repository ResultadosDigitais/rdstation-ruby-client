require 'spec_helper'

RSpec.describe RDStation::Emails do
  let(:emails_client) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: 'access_token'))
  end

  let(:emails_endpoint) { 'https://api.rd.services/platform/emails/' }

  let(:headers) do
    {
      Authorization: 'Bearer access_token',
      'Content-Type': 'application/json'
    }
  end

  let(:error_handler) do
    instance_double(RDStation::ErrorHandler, raise_error: 'mock raised errors')
  end

  before do
    allow(RDStation::ErrorHandler).to receive(:new).and_return(error_handler)
  end

  describe '#all' do
    let(:emails_list) do
      {
        items: [
          {
            id: 123,
            name: 'Marketing email',
            created_at: '2017-11-21T20:00:00-02:00',
            updated_at: '2017-11-21T20:00:00-02:00',
            send_at: '2017-11-21T20:00:00-02:00',
            leads_count: 55_000,
            status: 'FINISHED',
            type: 'email_model',
            is_predictive_sending: false,
            sending_is_imminent: false,
            behavior_score_info: {
              disengaged: false,
              engaged: false,
              indeterminate: false
            },
            campaign_id: 123,
            component_template_id: 123
          }
        ],
        total: 1
      }.to_json
    end

    it 'calls retryable_request' do
      expect(emails_client).to receive(:retryable_request)
      emails_client.all
    end

    context 'when the request is successful' do
      before do
        stub_request(:get, emails_endpoint)
          .with(headers: headers)
          .to_return(status: 200, body: emails_list)
      end

      it 'returns all emails' do
        response = emails_client.all
        expect(response).to include(emails_list)
      end
    end

    context 'when the request contains query params' do
      let(:query_params) do
        {
          page: 1,
          page_size: 10,
          query: 'Test',
          ids: '123, 456',
          types: 'CAMPAIGN_EMAIL'
        }
      end

      before do
        stub_request(:get, emails_endpoint)
          .with(headers: headers, query: query_params)
          .to_return(status: 200, body: emails_list)
      end

      it 'returns emails filtered by the query params' do
        response = emails_client.all(query_params)
        expect(response).to include(emails_list)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, emails_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        emails_client.all
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end

  describe '#by_id' do
    let(:id) { 123 }
    let(:emails_endpoint_by_id) { emails_endpoint + id.to_s }

    it 'calls retryable_request' do
      expect(emails_client).to receive(:retryable_request)
      emails_client.by_id(id)
    end

    context 'when the request is successful' do
      let(:email) do
        {
          id: 123,
          name: 'Marketing email',
          created_at: '2017-11-21T20:00:00-02:00',
          updated_at: '2017-11-21T20:00:00-02:00',
          send_at: '2017-11-21T20:00:00-02:00',
          leads_count: 55_000,
          status: 'FINISHED',
          type: 'email_model',
          is_predictive_sending: false,
          sending_is_imminent: false,
          behavior_score_info: {
            disengaged: false,
            engaged: false,
            indeterminate: false
          },
          campaign_id: 123,
          component_template_id: 123
        }.to_json
      end

      before do
        stub_request(:get, emails_endpoint_by_id)
          .with(headers: headers)
          .to_return(status: 200, body: email)
      end

      it 'returns the email' do
        response = emails_client.by_id(id)
        expect(response).to include(email)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, emails_endpoint_by_id)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        emails_client.by_id(id)
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end
end
