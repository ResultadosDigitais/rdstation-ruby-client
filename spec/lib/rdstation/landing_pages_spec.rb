require 'spec_helper'

RSpec.describe RDStation::LandingPages do
  let(:landing_pages_client) do
    described_class.new(authorization: RDStation::Authorization.new(access_token: 'access_token'))
  end
  let(:landing_pages_endpoint) { 'https://api.rd.services/platform/landing_pages/' }

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
    let(:landing_pages_list) do
      [
        {
          id: 1,
          title: "Minha Primeira Landing Page",
          created_at: "2021-09-22T14:14:04.510-03:00",
          upated_at: "2021-09-24T14:14:04.510-03:00",
          conversion_identifier: "dia-das-mães-2022",
          status: "PUBLISHED",
          has_active_experiment: false,
          had_experiment: false
        }
      ].to_json
    end

    it 'calls retryable_request' do
      expect(landing_pages_client).to receive(:retryable_request)
      landing_pages_client.all
    end

    context 'when the request is successful' do
      before do
        stub_request(:get, landing_pages_endpoint)
          .with(headers: headers)
          .to_return(status: 200, body: landing_pages_list)
      end

      it 'returns all email marketing analytics data' do
        response = landing_pages_client.all
        expect(response).to include(landing_pages_list)
      end
    end

    context 'when the request contains query params' do
      let(:query_params) { { page: 1 } }

      before do
        stub_request(:get, landing_pages_endpoint)
          .with(headers: headers, query: query_params)
          .to_return(status: 200, body: landing_pages_list)
      end

      it 'returns email marketing analytics data filtered by the query params' do
        response = landing_pages_client.all(query_params)
        expect(response).to include(landing_pages_list)
      end
    end

    context 'when the response contains errors' do
      before do
        stub_request(:get, landing_pages_endpoint)
          .with(headers: headers)
          .to_return(status: 400, body: { 'errors' => ['all errors'] }.to_json)
      end

      it 'calls raise_error on error handler' do
        landing_pages_client.all
        expect(error_handler).to have_received(:raise_error)
      end
    end
  end
end
