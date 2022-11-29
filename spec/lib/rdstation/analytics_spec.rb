require 'spec_helper'

RSpec.describe RDStation::Analytics do
  let(:analytics_client) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: 'access_token'))
  end

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

  describe '#email_marketing' do
    let(:analytics_endpoint) { 'https://api.rd.services/platform/analytics/emails' }
    let(:analytics_list) do
      {
        account_id: 1,
        query_date: {
          start_date: "2022-11-08",
          end_date: "2022-11-08"
        },
        emails: [
          {
            campaign_id: 6061281,
            campaign_name: "Desconto",
            send_at: "2021-08-06T17:26:39-03:00",
            contacts_count: 1000,
            email_dropped_count: 3,
            email_delivered_count: 997,
            email_bounced_count: 5,
            email_opened_count: 500,
            email_clicked_count: 500,
            email_unsubscribed_count: 4,
            email_spam_reported_count: 1,
            email_delivered_rate: 98.7,
            email_opened_rate: 46.9,
            email_clicked_rate: 36.5,
            email_spam_reported_rate: 0
          }
        ]
      }.to_json
    end

    it 'calls retryable_request' do
      expect(analytics_client).to receive(:retryable_request)
      analytics_client.email_marketing
    end

    context 'when the request is successful' do
      before do
        stub_request(:get, analytics_endpoint)
          .with(headers: headers)
          .to_return(status: 200, body: analytics_list)
      end

      it 'returns all email marketing analytics data' do
        response = analytics_client.email_marketing
        expect(response).to include(analytics_list)
      end
    end

    context 'when the request contains query params' do
      let(:query_params) do
        {
          start_date:'2022-11-2',
          end_date:'2022-11-8',
          campaign_id: '6061281'
        }
      end

      before do
        stub_request(:get, analytics_endpoint)
          .with(headers: headers, query: query_params)
          .to_return(status: 200, body: analytics_list)
      end

      it 'returns email marketing analytics data filtered by the query params' do
        response = analytics_client.email_marketing(query_params)
        expect(response).to include(analytics_list)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, analytics_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        analytics_client.email_marketing
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end

  describe '#conversions' do
    let(:analytics_endpoint) { 'https://api.rd.services/platform/analytics/conversions' }
    let(:analytics_list) do
      {
        account_id: 3127612,
        query_date: {
          start_date: "2022-11-17",
          end_date: "2022-11-17"
        },
        assets_type: "[LandingPage]",
        conversions: [
          {
            asset_id: 1495004,
            asset_identifier: "Como aumentar suas taxas de conversão",
            asset_type: "LandingPage",
            asset_created_at: "2022-06-30T19:11:05.191Z",
            asset_updated_at: "2022-06-30T20:11:05.191Z",
            visits_count: 1500,
            conversions_count: 150,
            conversion_rate: 10
          }
        ]
      }.to_json
    end

    it 'calls retryable_request' do
      expect(analytics_client).to receive(:retryable_request)
      analytics_client.conversions
    end

    context 'when the request is successful' do
      before do
        stub_request(:get, analytics_endpoint)
          .with(headers: headers)
          .to_return(status: 200, body: analytics_list)
      end

      it 'returns all email marketing analytics data' do
        response = analytics_client.conversions
        expect(response).to include(analytics_list)
      end
    end

    context 'when the request contains query params' do
      let(:query_params) do
        {
          start_date:'2022-11-17',
          end_date:'2022-11-17',
          asset_id: '1495004'
        }
      end

      before do
        stub_request(:get, analytics_endpoint)
          .with(headers: headers, query: query_params)
          .to_return(status: 200, body: analytics_list)
      end

      it 'returns conversions analytics data filtered by the query params' do
        response = analytics_client.conversions(query_params)
        expect(response).to include(analytics_list)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, analytics_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        analytics_client.conversions
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end
end
